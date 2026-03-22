INSERT INTO cover_index_temp (
    covercode, 
    upperlimit, 
    lowerlimit, 
    coverpercent, 
    indexdescription,
    vb_cm_code,
    user_ci_code)
VALUES (%s, %s, %s, %s, %s, %s, %s);