/* ---------------------------------------
    Community Concept Full Text Search
--------------------------------------- */

-- Add name search column (and index) to community concept table
ALTER TABLE commconcept
  ADD COLUMN search_vector tsvector;

CREATE INDEX idx_commconcept_search
  ON commconcept USING gin(search_vector);

-- Create function to construct a community name search vector for a
-- given community concept
CREATE OR REPLACE FUNCTION build_commconcept_search_vector(p_commconcept_id INTEGER)
RETURNS tsvector AS $$
DECLARE
  result tsvector;
BEGIN
  SELECT
    setweight(to_tsvector('simple', COALESCE(
      (SELECT string_agg(DISTINCT cn.commname, ' ')
       FROM commname cn
       WHERE cn.commname_id = cc.commname_id), '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(
      (SELECT string_agg(DISTINCT cn.commname, ' ')
       FROM commusage cu
       JOIN commname cn ON cu.commname_id = cn.commname_id
       WHERE cu.commconcept_id = cc.commconcept_id), '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(cc.commdescription, '')), 'C')
  INTO result
  FROM commconcept cc
  WHERE cc.commconcept_id = p_commconcept_id;

  RETURN result;
END;
$$ LANGUAGE plpgsql STABLE;

-- Create function to populate the community search column with a
-- constructed search vector for a single community concept record
CREATE OR REPLACE FUNCTION update_commconcept_search_vector(p_commconcept_id INTEGER)
RETURNS void AS $$
BEGIN
  UPDATE commconcept
  SET search_vector = build_commconcept_search_vector(p_commconcept_id)
  WHERE commconcept_id = p_commconcept_id;
END;
$$ LANGUAGE plpgsql;

-- Trigger for any changes to the commconcept record itself
CREATE OR REPLACE FUNCTION commconcept_search_trigger()
RETURNS trigger AS $$
BEGIN
  PERFORM update_commconcept_search_vector(NEW.commconcept_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_commconcept_search
AFTER INSERT OR UPDATE OF commname, commdescription ON commconcept
FOR EACH ROW
EXECUTE FUNCTION commconcept_search_trigger();

-- Trigger for commusage changes: Update all community concepts
-- associated with the modified community usage
CREATE OR REPLACE FUNCTION commusage_search_trigger()
RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    PERFORM update_commconcept_search_vector(OLD.commconcept_id);
  ELSE
    PERFORM update_commconcept_search_vector(NEW.commconcept_id);
  END IF;
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_commusage_search
AFTER INSERT OR UPDATE OR DELETE ON commusage
FOR EACH ROW
EXECUTE FUNCTION commusage_search_trigger();

-- Trigger for commname changes: Update all community concepts
-- associated with the modified community name either directly, or
-- indirectly through a community status record
CREATE OR REPLACE FUNCTION commname_search_trigger()
RETURNS trigger AS $$
DECLARE
  affected_commname_id INTEGER;
  affected_concepts INTEGER[];
BEGIN
  IF TG_OP = 'DELETE' THEN
    affected_commname_id := OLD.commname_id;
  ELSE
    affected_commname_id := NEW.commname_id;
  END IF;

  SELECT ARRAY_AGG(DISTINCT commconcept_id)
  INTO affected_concepts
  FROM (
    SELECT cc.commconcept_id
    FROM commconcept cc
    WHERE cc.commname_id = affected_commname_id
    UNION
    SELECT cu.commconcept_id
    FROM commusage cu
    WHERE cu.commname_id = affected_commname_id
  ) AS all_concepts;

  IF affected_concepts IS NOT NULL THEN
    UPDATE commconcept cc
    SET search_vector = build_commconcept_search_vector(cc.commconcept_id)
    WHERE cc.commconcept_id = ANY(affected_concepts);
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_commname_search
AFTER INSERT OR UPDATE OR DELETE ON commname
FOR EACH ROW
EXECUTE FUNCTION commname_search_trigger();

-- Populate search vectors for all current comm concepts
UPDATE commconcept
  SET search_vector = build_commconcept_search_vector(commconcept_id);
