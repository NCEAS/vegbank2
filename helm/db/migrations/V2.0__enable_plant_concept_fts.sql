/* -----------------------------------
    Plant Concept Full Text Search
----------------------------------- */

-- Add name search column (and index) to plant concept table
ALTER TABLE plantconcept
  ADD COLUMN search_vector tsvector;

CREATE INDEX idx_plantconcept_search
  ON plantconcept USING gin(search_vector);

-- Create function to construct a plant name search vector for a given
-- plant concept
CREATE OR REPLACE FUNCTION build_plantconcept_search_vector(p_plantconcept_id INTEGER)
RETURNS tsvector AS $$
DECLARE
  result tsvector;
BEGIN
  SELECT
    setweight(to_tsvector('simple', COALESCE(
      (SELECT string_agg(DISTINCT pn.plantname, ' ')
       FROM plantname pn
       WHERE pn.plantname_id = pc.plantname_id), '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(
      (SELECT string_agg(DISTINCT pn.plantname, ' ')
       FROM plantusage pu
       JOIN plantname pn ON pu.plantname_id = pn.plantname_id
       WHERE pu.plantconcept_id = pc.plantconcept_id), '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(pc.plantdescription, '')), 'C')
  INTO result
  FROM plantconcept pc
  WHERE pc.plantconcept_id = p_plantconcept_id;

  RETURN result;
END;
$$ LANGUAGE plpgsql STABLE;

-- Create function to populate the plant search column with a
-- constructed search vector for a single plant concept record
CREATE OR REPLACE FUNCTION update_plantconcept_search_vector(p_plantconcept_id INTEGER)
RETURNS void AS $$
BEGIN
  UPDATE plantconcept
  SET search_vector = build_plantconcept_search_vector(p_plantconcept_id)
  WHERE plantconcept_id = p_plantconcept_id;
END;
$$ LANGUAGE plpgsql;

-- Trigger for any changes to the plantconcept record itself
CREATE OR REPLACE FUNCTION plantconcept_search_trigger()
RETURNS trigger AS $$
BEGIN
  PERFORM update_plantconcept_search_vector(NEW.plantconcept_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_plantconcept_search
AFTER INSERT OR UPDATE OF plantname, plantdescription ON plantconcept
FOR EACH ROW
EXECUTE FUNCTION plantconcept_search_trigger();

-- Trigger for plantusage changes: Update all plant concepts associated
-- with the modified plant usage
CREATE OR REPLACE FUNCTION plantusage_search_trigger()
RETURNS trigger AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    PERFORM update_plantconcept_search_vector(OLD.plantconcept_id);
  ELSE
    PERFORM update_plantconcept_search_vector(NEW.plantconcept_id);
  END IF;
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_plantusage_search
AFTER INSERT OR UPDATE OR DELETE ON plantusage
FOR EACH ROW
EXECUTE FUNCTION plantusage_search_trigger();

-- Trigger for plantname changes: Update all plant concepts
-- associated with the modified plant name either directly, or
-- indirectly through a plant status record
CREATE OR REPLACE FUNCTION plantname_search_trigger()
RETURNS trigger AS $$
DECLARE
  affected_plantname_id INTEGER;
  affected_concepts INTEGER[];
BEGIN
  IF TG_OP = 'DELETE' THEN
    affected_plantname_id := OLD.plantname_id;
  ELSE
    affected_plantname_id := NEW.plantname_id;
  END IF;

  SELECT ARRAY_AGG(DISTINCT plantconcept_id)
  INTO affected_concepts
  FROM (
    SELECT pc.plantconcept_id
    FROM plantconcept pc
    WHERE pc.plantname_id = affected_plantname_id
    UNION
    SELECT pu.plantconcept_id
    FROM plantusage pu
    WHERE pu.plantname_id = affected_plantname_id
  ) AS all_concepts;

  IF affected_concepts IS NOT NULL THEN
    UPDATE plantconcept pc
    SET search_vector = build_plantconcept_search_vector(pc.plantconcept_id)
    WHERE pc.plantconcept_id = ANY(affected_concepts);
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_plantname_search
AFTER INSERT OR UPDATE OR DELETE ON plantname
FOR EACH ROW
EXECUTE FUNCTION plantname_search_trigger();

-- Populate search vectors for all current plant concepts
UPDATE plantconcept
  SET search_vector = build_plantconcept_search_vector(plantconcept_id);
