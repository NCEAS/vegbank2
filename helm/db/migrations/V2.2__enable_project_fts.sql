/* -----------------------------
    Project Full Text Search
----------------------------- */

-- Add name/description search column (and index) to project table
ALTER TABLE project
  ADD COLUMN search_vector tsvector;

CREATE INDEX idx_project_search
  ON project USING gin(search_vector);

-- Create function to construct project search vector for a given project
CREATE OR REPLACE FUNCTION build_project_search_vector(p_project_id INTEGER)
RETURNS tsvector AS $$
DECLARE
  result tsvector;
BEGIN
  SELECT
    setweight(to_tsvector('simple', COALESCE(pj.projectname, '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(pj.projectdescription, '')), 'B')
  INTO result
  FROM project pj
  WHERE pj.project_id = p_project_id;

  RETURN result;
END;
$$ LANGUAGE plpgsql STABLE;

-- Create function to populate the project search column with a
-- constructed search vector for a single project record
CREATE OR REPLACE FUNCTION update_project_search_vector(p_project_id INTEGER)
RETURNS void AS $$
BEGIN
  UPDATE project
  SET search_vector = build_project_search_vector(p_project_id)
  WHERE project_id = p_project_id;
END;
$$ LANGUAGE plpgsql;

-- Trigger for any changes to the project record itself
CREATE OR REPLACE FUNCTION project_search_trigger()
RETURNS trigger AS $$
BEGIN
  PERFORM update_project_search_vector(NEW.project_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_project_search
AFTER INSERT OR UPDATE OF projectname, projectdescription ON project
FOR EACH ROW
EXECUTE FUNCTION project_search_trigger();

-- Populate search vectors for all current projects
UPDATE project
  SET search_vector = build_project_search_vector(project_id);
