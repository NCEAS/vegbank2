SELECT
    count(*)
FROM
    commConcept
    left join commname on commconcept.commname_id = commname.commname_id
    left join reference on commName.reference_id = reference.reference_id;