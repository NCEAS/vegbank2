INSERT INTO stem_count_temp
    (
        user_sc_code,
        user_tm_code,
        vb_tm_code,
        stemcount,
        stemdiameter,
        stemdiameteraccuracy,
        stemheight,
        stemheightaccuracy,
        stemtaxonarea
    )
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);