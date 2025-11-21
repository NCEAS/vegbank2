/* ---------------------------
    Party Full Text Search
--------------------------- */

-- Add name/organization search column (and index) to party table
ALTER TABLE party
  ADD COLUMN search_vector tsvector;

CREATE INDEX idx_party_search
  ON party USING gin(search_vector);

-- Create function to construct plot party search vector for a given party
CREATE OR REPLACE FUNCTION build_party_search_vector(p_party_id INTEGER)
RETURNS tsvector AS $$
DECLARE
  result tsvector;
BEGIN
  SELECT
    setweight(to_tsvector('simple', COALESCE(py.organizationname, '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(py.surname, '')), 'A') ||
    setweight(to_tsvector('simple', COALESCE(py.givenname, '')), 'B')
  INTO result
  FROM party py
  WHERE py.party_id = p_party_id;

  RETURN result;
END;
$$ LANGUAGE plpgsql STABLE;

-- Create function to populate the party search column with a
-- constructed search vector for a single party record
CREATE OR REPLACE FUNCTION update_party_search_vector(p_party_id INTEGER)
RETURNS void AS $$
BEGIN
  UPDATE party
  SET search_vector = build_party_search_vector(p_party_id)
  WHERE party_id = p_party_id;
END;
$$ LANGUAGE plpgsql;

-- Trigger for any changes to the party record itself
CREATE OR REPLACE FUNCTION party_search_trigger()
RETURNS trigger AS $$
BEGIN
  PERFORM update_party_search_vector(NEW.party_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_party_search
AFTER INSERT OR UPDATE OF organizationname, surname, givenname ON party
FOR EACH ROW
EXECUTE FUNCTION party_search_trigger();

-- Populate search vectors for all current parties
UPDATE party
  SET search_vector = build_party_search_vector(party_id);
