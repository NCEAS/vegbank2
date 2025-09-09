CREATE AGGREGATE concat (
        BASETYPE = text,
        SFUNC = textcat,
        STYPE = text,
        INITCOND = ''
);