/* --------------------------------------
    Plot Observation Full Text Search
-------------------------------------- */

-- Add Observation text search column
ALTER TABLE observation
  ADD COLUMN search_vector tsvector;
-- ... and corresponding index
CREATE INDEX idx_observation_search
  ON observation USING gin(search_vector);

-- Create function to construct the Observation search vector for a
-- given observation
CREATE OR REPLACE FUNCTION build_observation_search_vector(p_observation_id INTEGER)
RETURNS tsvector AS $$
DECLARE
  result tsvector;
BEGIN
  SELECT
    setweight(to_tsvector('simple', COALESCE(ob.authorobscode, '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(
      (SELECT string_agg(DISTINCT pl.authorplotcode, ' ')
         FROM plot pl
         WHERE pl.plot_id = ob.plot_id), '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(
      (SELECT string_agg(DISTINCT np.placename, ' ')
         FROM plot pl
         JOIN place p ON p.plot_id = pl.plot_id
         JOIN namedplace np ON np.namedplace_id = p.namedplace_id
         WHERE pl.plot_id = ob.plot_id), '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(
      (SELECT string_agg(DISTINCT txo.authorplantname, ' ')
         FROM taxonobservation txo
         WHERE txo.observation_id = ob.observation_id), '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(
      (SELECT string_agg(DISTINCT pn.plantname, ' ')
         FROM plantname pn
         JOIN plantconcept pc USING (plantname_id)
         JOIN taxoninterpretation txi USING (plantconcept_id)
         JOIN taxonobservation txo USING (taxonobservation_id)
         WHERE txo.observation_id = ob.observation_id), '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(
      (SELECT string_agg(DISTINCT pn.plantname, ' ')
         FROM plantname pn
         JOIN plantusage pu USING(plantname_id)
         JOIN taxoninterpretation txi USING (plantconcept_id)
         JOIN taxonobservation txo USING (taxonobservation_id)
         WHERE txo.observation_id = ob.observation_id), '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(
      (SELECT string_agg(DISTINCT cn.commname, ' ')
         FROM commname cn
         JOIN commconcept cc USING (commname_id)
         JOIN comminterpretation ci USING (commconcept_id)
         JOIN commclass cl USING (commclass_id)
         WHERE cl.observation_id = ob.observation_id), '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(
      (SELECT string_agg(DISTINCT cn.commname, ' ')
         FROM commname cn
         JOIN commusage cu USING(commname_id)
         JOIN comminterpretation ci USING (commconcept_id)
         JOIN commclass cl USING (commclass_id)
         WHERE cl.observation_id = ob.observation_id), '')), 'A')
  INTO result
  FROM observation ob
  WHERE ob.observation_id = p_observation_id;

  RETURN result;
END;
$$ LANGUAGE plpgsql STABLE;

-- Create function to populate the observation search column with a
-- constructed search vector for a *single* observation record
CREATE OR REPLACE FUNCTION update_observation_search_vector(p_observation_id INTEGER)
RETURNS void AS $$
BEGIN
  UPDATE observation
  SET search_vector = build_observation_search_vector(p_observation_id)
  WHERE observation_id = p_observation_id;
END;
$$ LANGUAGE plpgsql;

-- Create function to populate the observation search column with a
-- constructed search vector for a *batch* of observation records
CREATE OR REPLACE FUNCTION update_observation_search_vectors(p_observation_ids INTEGER[])
RETURNS void AS $$
BEGIN
  UPDATE observation
  SET search_vector = build_observation_search_vector(observation_id)
  WHERE observation_id = ANY(p_observation_ids);
END;
$$ LANGUAGE plpgsql;

-- TRIGGER 1 on INS/UPD of Observation plot_id or authorobscode
CREATE OR REPLACE FUNCTION update_obsearch_from_observation()
RETURNS trigger AS $$
BEGIN
  PERFORM update_observation_search_vector(NEW.observation_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_observation_obsearch
  AFTER INSERT OR UPDATE OF plot_id, authorobscode
  ON observation
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_observation();

-- TRIGGER 2 on UPD of Plot authorplotcode
CREATE OR REPLACE FUNCTION update_obsearch_from_plot()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM update_observation_search_vectors(
    ARRAY(
      SELECT observation_id FROM observation
      WHERE plot_id = NEW.plot_id));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_plot_to_ob_search
  AFTER UPDATE OF authorplotcode
  ON plot
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_plot();

-- TRIGGER 3 on INS/DEL/UPD of Place plot_id or namedplace_id
CREATE OR REPLACE FUNCTION update_obsearch_from_place()
RETURNS TRIGGER AS $$
DECLARE
  obs_ids INTEGER[];

BEGIN
  IF TG_OP = 'DELETE' THEN
    obs_ids := ARRAY(
        SELECT observation_id FROM observation
        WHERE plot_id = OLD.plot_id);
  ELSIF TG_OP = 'UPDATE' AND (
          OLD.plot_id IS DISTINCT FROM NEW.plot_id OR
          OLD.namedplace_id IS DISTINCT FROM NEW.namedplace_id) THEN
    obs_ids := ARRAY(
        SELECT observation_id FROM observation
        WHERE plot_id IN (OLD.plot_id, NEW.plot_id));
  ELSE
    obs_ids := ARRAY(
        SELECT observation_id FROM observation
        WHERE plot_id = NEW.plot_id);
  END IF;

  PERFORM update_observation_search_vectors(obs_ids);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_place_to_ob_search
  AFTER INSERT OR DELETE OR UPDATE OF plot_id, namedplace_id
  ON place
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_place();

-- TRIGGER 4 on UPD of NamedPlace placename
CREATE OR REPLACE FUNCTION update_obsearch_from_namedplace()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM update_observation_search_vectors(
    ARRAY(
      SELECT DISTINCT ob.observation_id
      FROM observation ob
      JOIN plot pl ON pl.plot_id = ob.plot_id
      JOIN place p ON p.plot_id = pl.plot_id
      WHERE p.namedplace_id = NEW.namedplace_id));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_namedplace_to_ob_search
  AFTER UPDATE OF placename
  ON namedplace
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_namedplace();

-- TRIGGER 5 on DEL/UPD of CommClass observation_id
CREATE OR REPLACE FUNCTION update_obsearch_from_commclass()
RETURNS TRIGGER AS $$
DECLARE
  obs_ids INTEGER[];

BEGIN
  IF TG_OP = 'DELETE' THEN
    obs_ids := ARRAY[OLD.observation_id];
  ELSIF TG_OP = 'UPDATE' AND
        OLD.observation_id IS DISTINCT FROM NEW.observation_id THEN
    obs_ids := ARRAY[OLD.observation_id, NEW.observation_id];
  ELSE
    obs_ids := ARRAY[NEW.observation_id];
  END IF;
  PERFORM update_observation_search_vectors(obs_ids);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_commclass_to_obsearch
  AFTER DELETE OR UPDATE OF observation_id
  ON commclass
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_commclass();

-- TRIGGER 6 on INS/DEL/UPD of CommInterpretation cl_id or cc_id
CREATE OR REPLACE FUNCTION update_obsearch_from_comminterp()
RETURNS TRIGGER AS $$
DECLARE
  obs_ids INTEGER[];

BEGIN
  IF TG_OP = 'DELETE' THEN
    obs_ids := ARRAY(
        SELECT observation_id FROM commclass
        WHERE commclass_id = OLD.commclass_id);
  ELSIF TG_OP = 'UPDATE' AND (
      OLD.commclass_id IS DISTINCT FROM NEW.commclass_id OR
      OLD.commconcept_id IS DISTINCT FROM NEW.commconcept_id) THEN
    obs_ids := ARRAY(
        SELECT observation_id FROM commclass
        WHERE commclass_id IN (OLD.commclass_id, NEW.commclass_id));
  ELSE
    obs_ids := ARRAY(
        SELECT observation_id FROM commclass
        WHERE commclass_id = NEW.commclass_id);
  END IF;
  PERFORM update_observation_search_vectors(obs_ids);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_comminterp_to_obsearch
  AFTER INSERT OR DELETE OR UPDATE OF commclass_id, commconcept_id
  ON comminterpretation
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_comminterp();

-- TRIGGER 7 on UPD of CommConcept commname_id
CREATE OR REPLACE FUNCTION update_obsearch_from_commconcept()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM update_observation_search_vectors(
    ARRAY(
      SELECT DISTINCT cl.observation_id
      FROM commclass cl
      JOIN comminterpretation ci USING (commclass_id)
      WHERE ci.commconcept_id = NEW.commconcept_id));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_commconcept_to_obsearch
  AFTER UPDATE OF commname_id
  ON commconcept
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_commconcept();

-- TRIGGER 8 on INS/DEL/UPD of CommUsage commname_id or commconcept_id
CREATE OR REPLACE FUNCTION update_obsearch_from_commusage()
RETURNS TRIGGER AS $$
DECLARE
  obs_ids INTEGER[];
BEGIN
  IF TG_OP = 'DELETE' THEN
    obs_ids := ARRAY(
        SELECT DISTINCT cl.observation_id
        FROM commclass cl
        JOIN comminterpretation ci USING (commclass_id)
        WHERE ci.commconcept_id = OLD.commconcept_id);
  ELSE
    obs_ids := ARRAY(
        SELECT DISTINCT cl.observation_id
        FROM commclass cl
        JOIN comminterpretation ci USING (commclass_id)
        WHERE ci.commconcept_id = NEW.commconcept_id);
  END IF;
  PERFORM update_observation_search_vectors(obs_ids);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_commusage_to_obsearch
  AFTER INSERT OR DELETE OR UPDATE OF commname_id, commconcept_id
  ON commusage
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_commusage();

-- TRIGGER 9 on UPD of CommName commname
CREATE OR REPLACE FUNCTION update_obsearch_from_commname()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM update_observation_search_vectors(
    ARRAY(
      SELECT DISTINCT cl.observation_id
      FROM commclass cl
      JOIN comminterpretation ci USING (commclass_id)
      JOIN commconcept cc USING (commconcept_id)
      WHERE cc.commname_id = NEW.commname_id
      UNION
      SELECT DISTINCT cl.observation_id
      FROM commclass cl
      JOIN comminterpretation ci USING (commclass_id)
      JOIN commusage cu USING (commconcept_id)
      WHERE cu.commname_id = NEW.commname_id));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_commname_to_obsearch
  AFTER UPDATE OF commname
  ON commname
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_commname();

-- TRIGGER 10 on INS/DEL/UPD of TaxonObservation obs_id or authorplantname
CREATE OR REPLACE FUNCTION update_obsearch_from_taxonobs()
RETURNS TRIGGER AS $$
DECLARE
  obs_ids INTEGER[];

BEGIN
  IF TG_OP = 'DELETE' THEN
    obs_ids := ARRAY[OLD.observation_id];
  ELSIF TG_OP = 'UPDATE' AND
        OLD.observation_id IS DISTINCT FROM NEW.observation_id THEN
    obs_ids := ARRAY[OLD.observation_id, NEW.observation_id];
  ELSE
    obs_ids := ARRAY[NEW.observation_id];
  END IF;
  PERFORM update_observation_search_vectors(obs_ids);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_taxonobs_to_obsearch
  AFTER INSERT OR DELETE OR UPDATE OF observation_id, authorplantname
  ON taxonobservation
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_taxonobs();

-- TRIGGER 11 on INS/DEL/UPD of TaxonInterpretation txo_id or pc_id
CREATE OR REPLACE FUNCTION update_obsearch_from_taxoninterp()
RETURNS TRIGGER AS $$
DECLARE
  obs_ids INTEGER[];

BEGIN
  IF TG_OP = 'DELETE' THEN
    obs_ids := ARRAY(
        SELECT observation_id FROM taxonobservation
        WHERE taxonobservation_id = OLD.taxonobservation_id);
  ELSIF TG_OP = 'UPDATE' AND (
      OLD.taxonobservation_id IS DISTINCT FROM NEW.taxonobservation_id OR
      OLD.plantconcept_id IS DISTINCT FROM NEW.plantconcept_id) THEN
    obs_ids := ARRAY(
        SELECT observation_id FROM taxonobservation
        WHERE taxonobservation_id IN (OLD.taxonobservation_id,
                                      NEW.taxonobservation_id));
  ELSE
    obs_ids := ARRAY(
        SELECT observation_id FROM taxonobservation
        WHERE taxonobservation_id = NEW.taxonobservation_id);
  END IF;
  PERFORM update_observation_search_vectors(obs_ids);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_taxoninterp_to_obsearch
  AFTER INSERT OR DELETE OR UPDATE OF taxonobservation_id, plantconcept_id
  ON taxoninterpretation
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_taxoninterp();

-- TRIGGER 12 on UPD of PlantConcept plantname_id
CREATE OR REPLACE FUNCTION update_obsearch_from_plantconcept()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM update_observation_search_vectors(
    ARRAY(
      SELECT DISTINCT txo.observation_id
      FROM taxonobservation txo
      JOIN taxoninterpretation txi USING (taxonobservation_id)
      WHERE txi.plantconcept_id = NEW.plantconcept_id)
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_plantconcept_to_obsearch
  AFTER UPDATE OF plantname_id
  ON plantconcept
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_plantconcept();

-- TRIGGER 13 on INS/DEL/UPD of PlantUsage plantname_id or plantconcept_id
CREATE OR REPLACE FUNCTION update_obsearch_from_plantusage()
RETURNS TRIGGER AS $$
DECLARE
  obs_ids INTEGER[];
BEGIN
  IF TG_OP = 'DELETE' THEN
    obs_ids := ARRAY(
        SELECT DISTINCT txo.observation_id
        FROM taxonobservation txo
        JOIN taxoninterpretation txi USING (taxonobservation_id)
        WHERE txi.plantconcept_id = OLD.plantconcept_id);
  ELSE
    obs_ids := ARRAY(
        SELECT DISTINCT txo.observation_id
        FROM taxonobservation txo
        JOIN taxoninterpretation txi USING (taxonobservation_id)
        WHERE txi.plantconcept_id = NEW.plantconcept_id);
  END IF;
  PERFORM update_observation_search_vectors(obs_ids);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_plantusage_to_obsearch
  AFTER INSERT OR DELETE OR UPDATE OF plantname_id, plantconcept_id
  ON plantusage
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_plantusage();

-- TRIGGER 14 on UPD of PlantName plantname
CREATE OR REPLACE FUNCTION update_obsearch_from_plantname()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM update_observation_search_vectors(
    ARRAY(
      SELECT DISTINCT txo.observation_id
      FROM taxonobservation txo
      JOIN taxoninterpretation txi USING (taxonobservation_id)
      JOIN plantconcept pc USING (plantconcept_id)
      WHERE pc.plantname_id = NEW.plantname_id
      UNION
      SELECT DISTINCT txo.observation_id
      FROM taxonobservation txo
      JOIN taxoninterpretation txi USING (taxonobservation_id)
      JOIN plantusage pu USING (plantconcept_id)
      WHERE pu.plantname_id = NEW.plantname_id));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_plantname_to_obsearch
  AFTER UPDATE OF plantname
  ON plantname
  FOR EACH ROW
  EXECUTE FUNCTION update_obsearch_from_plantname();

-- Populate Observation search_vector
UPDATE observation
  SET search_vector = build_observation_search_vector(observation_id);
