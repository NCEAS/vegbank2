INSERT INTO community_interpretation_temp (
    user_ci_code,
    vb_cl_code,
    vb_cc_code,
    classfit,
    classconfidence,
    interpnotes
)
VALUES(
    %s, %s, %s, %s, %s, %s
);