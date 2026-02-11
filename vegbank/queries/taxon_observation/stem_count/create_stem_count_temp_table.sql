CREATE TEMPORARY TABLE stem_count_temp(
    user_sc_code TEXT NOT NULL,
    user_tm_code TEXT NOT NULL,
    vb_tm_code TEXT NOT NULL,
    stemcount integer NOT NULL,
    stemdiameter double precision,
    stemdiameteraccuracy double precision,
    stemheight double precision,
    stemheightaccuracy double precision,
    stemtaxonarea double precision
);