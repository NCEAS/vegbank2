--- VIEWS MUST BE DROPPED in drop_vegbank_views first!
CREATE VIEW view_party_public AS
SELECT party.party_id,
    accessioncode,
    salutation,
    surname,
    givenname,
    middlename,
    organizationname,
    contactinstructions,
    email
FROM party
    LEFT JOIN usr ON party.party_ID = usr.party_ID
WHERE usr.usr_id is NULL
    OR usr.permission_type > 1;
DROP VIEW IF EXISTS view_busRule_plotsizeshape;
CREATE VIEW view_busRule_plotsizeshape AS
SELECT (project_id),
    (
        select projectName
        from project
        where project.project_ID = observation.projecT_ID
    ) as projectName,
    count(1) as plotcount
from plot
    inner join observation on plot.plot_ID = observation.plot_ID
where (
        (area is null)
        and (
            shape is null
            or (
                ((shape) <> 'Plotless')
                and (upper(shape) not like 'RELEV%')
            )
        )
    )
group by project_ID;
DROP VIEW IF EXISTS view_busRule_duplStratumType;
CREATE VIEW view_busRule_duplStratumType AS
SELECT count(1),
    stratummethod_id,
    stratumindex
FROM stratumType
GROUP BY stratummethod_id,
    stratumindex
HAVING count(1) > 1;
DROP VIEW IF EXISTS view_busRule_duplcovercode;
CREATE VIEW view_busRule_duplcovercode AS
SELECT count(1),
    covermethod_id,
    covercode
FROM coverIndex
GROUP BY covermethod_id,
    covercode
HAVING count(1) > 1;
-- EMBARGO views    
DROP VIEW IF EXISTS view_emb_embargo_complete;
DROP VIEW IF EXISTS view_emb_embargo_currentfullonly;
CREATE VIEW view_emb_embargo_currentfullonly AS
SELECT *
FROM embargo
WHERE (
        ((defaultStatus) = 6)
        AND ((embargoStart) < Now())
        AND ((embargoStop) > Now())
    );
CREATE VIEW view_emb_embargo_complete AS
SELECT Coalesce(emb.defaultStatus, 0) AS currentEmb,
    plot.plot_id
FROM plot
    LEFT JOIN view_emb_embargo_currentfullonly AS emb ON plot.PLOT_ID = emb.plot_ID;
CREATE VIEW view_notEmb_classContributor AS
SELECT *
FROM classContributor
where emb_classContributor < 6;
CREATE VIEW view_notEmb_commClass AS
SELECT *
FROM commClass
where emb_commClass < 6;
CREATE VIEW view_notEmb_commInterpretation AS
SELECT *
FROM commInterpretation
where emb_commInterpretation < 6;
CREATE VIEW view_notEmb_disturbanceObs AS
SELECT *
FROM disturbanceObs
where emb_disturbanceObs < 6;
CREATE VIEW view_notEmb_observation AS
SELECT *
FROM observation
where emb_observation < 6;
CREATE VIEW view_notEmb_observationContributor AS
SELECT observationContributor.*
FROM observationContributor
    inner join observation on observationContributor.observation_ID = observation.observation_ID
where observation.emb_observation < 6;
CREATE VIEW view_notEmb_plot AS
SELECT *
FROM plot
where emb_plot < 6;
CREATE VIEW view_notEmb_soilObs AS
SELECT *
FROM soilObs
where emb_soilObs < 6;
CREATE VIEW view_notEmb_stemCount AS
SELECT *
FROM stemCount
where emb_stemCount < 6;
CREATE VIEW view_notEmb_stemLocation AS
SELECT *
FROM stemLocation
where emb_stemLocation < 6;
CREATE VIEW view_notEmb_taxonAlt AS
SELECT *
FROM taxonAlt
where emb_taxonAlt < 6;
CREATE VIEW view_notEmb_taxonImportance AS
SELECT *
FROM taxonImportance
where emb_taxonImportance < 6;
CREATE VIEW view_notEmb_taxonInterpretation AS
SELECT *
FROM taxonInterpretation
where emb_taxonInterpretation < 6;
CREATE VIEW view_notEmb_taxonObservation AS
SELECT *
FROM taxonObservation
where emb_taxonObservation < 6;
CREATE VIEW view_export_classContributor AS
SELECT *
FROM view_notemb_classContributor;
CREATE VIEW view_export_commClass AS
SELECT *
FROM view_notemb_commClass;
CREATE VIEW view_export_commInterpretation AS
SELECT *
FROM view_notemb_commInterpretation;
CREATE VIEW view_export_disturbanceObs AS
SELECT *
FROM view_notemb_disturbanceObs;
CREATE VIEW view_export_observation AS
SELECT *
FROM view_notemb_observation;
CREATE VIEW view_export_observationcontributor AS
SELECT *
FROM view_notemb_observationcontributor;
-- PLOT requires shifting field names to remove some fields for confidential plots
CREATE VIEW view_export_plot_pre AS
SELECT plot_id,
    authorplotcode,
    reference_id,
    parent_id,
    locationaccuracy,
    confidentialitystatus,
    latitude,
    longitude,
    CASE
        WHEN confidentialitystatus > 0 THEN null
        ELSE authorlocation
    END as authorlocation_emb,
    CASE
        WHEN confidentialitystatus > 0 THEN null
        ELSE locationnarrative
    END as locationnarrative_emb,
    azimuth,
    dsgpoly,
    shape,
    area,
    standsize,
    placementmethod,
    permanence,
    layoutnarrative,
    elevation,
    elevationaccuracy,
    elevationrange,
    slopeaspect,
    minslopeaspect,
    maxslopeaspect,
    slopegradient,
    minslopegradient,
    maxslopegradient,
    topoposition,
    landform,
    surficialdeposits,
    rocktype,
    stateprovince,
    country,
    submitter_surname,
    submitter_givenname,
    submitter_email,
    notespublic,
    notesmgt,
    revisions,
    dateentered,
    emb_plot,
    plotrationalenarrative,
    accessioncode
FROM view_notemb_plot;
CREATE VIEW view_export_plot AS
SELECT plot_id,
    authorplotcode,
    reference_id,
    parent_id,
    locationaccuracy,
    confidentialitystatus,
    latitude,
    longitude,
    authorlocation_emb as authorlocation,
    locationnarrative_emb as locationnarrative,
    azimuth,
    dsgpoly,
    shape,
    area,
    standsize,
    placementmethod,
    permanence,
    layoutnarrative,
    elevation,
    elevationaccuracy,
    elevationrange,
    slopeaspect,
    minslopeaspect,
    maxslopeaspect,
    slopegradient,
    minslopegradient,
    maxslopegradient,
    topoposition,
    landform,
    surficialdeposits,
    rocktype,
    stateprovince,
    country,
    submitter_surname,
    submitter_givenname,
    submitter_email,
    notespublic,
    notesmgt,
    revisions,
    dateentered,
    emb_plot,
    plotrationalenarrative,
    accessioncode
FROM view_export_plot_pre;
CREATE VIEW view_export_soilObs AS
SELECT *
FROM view_notemb_soilObs;
CREATE VIEW view_export_stemCount AS
SELECT *
FROM view_notemb_stemCount;
CREATE VIEW view_export_stemLocation AS
SELECT *
FROM view_notemb_stemLocation;
CREATE VIEW view_export_taxonAlt AS
SELECT *
FROM view_notemb_taxonAlt;
CREATE VIEW view_export_taxonImportance AS
SELECT *
FROM view_notemb_taxonImportance;
CREATE VIEW view_export_taxonInterpretation AS
SELECT *
FROM view_notemb_taxonInterpretation;
CREATE VIEW view_export_taxonObservation AS
SELECT *
FROM view_notemb_taxonObservation;
------------------
-- END EMBARGO VIEWS 
-------------------
CREATE VIEW view_reference_transl AS
SELECT CASE
        WHEN shortName IS NULL THEN CASE
            WHEN title IS NULL THEN CASE
                WHEN fulltext IS NULL THEN '[poorly documented reference]'
                ELSE CASE
                    WHEN length(fulltext) > 35 THEN substr(fulltext, 1, 32) || '...'
                    ELSE fulltext
                END
            END
            ELSE title
        END
        ELSE shortName
    END AS reference_id_transl,
    reference_id
from reference;
CREATE VIEW view_plantconcept_transl AS
SELECT plantconcept_id,
    plantname_id,
    plantname,
    reference_id,
    plantname || ' [' || (
        select reference_id_transl
        FROM view_reference_transl
        where view_reference_transl.reference_id = plantconcept.reference_id
    ) || ']' as plantconcept_id_transl
FROM plantconcept;
CREATE VIEW view_commconcept_transl AS
SELECT commconcept_id,
    commname_id,
    commname,
    reference_id,
    commname || ' [' || (
        select reference_id_transl
        FROM view_reference_transl
        where view_reference_transl.reference_id = commconcept.reference_id
    ) || ']' as commconcept_id_transl
FROM commconcept;
CREATE VIEW view_party_transl AS
SELECT CASE
        WHEN surname is null THEN CASE
            WHEN organizationname IS NULL THEN '[poorly documented party]'
            ELSE organizationname || ' (organization)'
        END
        ELSE surname || CASE
            WHEN givenname IS NULL THEN ''
            ELSE ', ' || COALESCE(givenname, '')
        END
    END AS party_id_transl,
    party_id
FROM party;
--- browsing by party views: -----
CREATE VIEW view_browseparty_obscontrib AS
SELECT observationContributor.PARTY_ID,
    observationContributor.OBSERVATION_ID
FROM view_notemb_observation as observation
    INNER JOIN observationContributor ON observation.OBSERVATION_ID = observationContributor.OBSERVATION_ID
GROUP BY observationContributor.PARTY_ID,
    observationContributor.OBSERVATION_ID;
CREATE VIEW view_browseparty_projectcontrib AS
SELECT observation_1.OBSERVATION_ID,
    projectContributor.PARTY_ID
FROM (
        project
        INNER JOIN view_notemb_observation AS observation_1 ON project.PROJECT_ID = observation_1.PROJECT_ID
    )
    INNER JOIN projectContributor ON project.PROJECT_ID = projectContributor.PROJECT_ID
GROUP BY observation_1.OBSERVATION_ID,
    projectContributor.PARTY_ID;
CREATE VIEW view_browseparty_classcontrib AS
SELECT observation_2.OBSERVATION_ID,
    classContributor.PARTY_ID
FROM view_notemb_observation AS observation_2
    INNER JOIN (
        commClass
        INNER JOIN classContributor ON commClass.COMMCLASS_ID = classContributor.COMMCLASS_ID
    ) ON observation_2.OBSERVATION_ID = commClass.OBSERVATION_ID
GROUP BY observation_2.OBSERVATION_ID,
    classContributor.PARTY_ID;
CREATE VIEW view_browseparty_all AS
SELECT OBSERVATION_ID,
    PARTY_ID
FROM view_browseparty_classcontrib
union
SELECT OBSERVATION_ID,
    PARTY_ID
FROM view_browseparty_projectcontrib
UNION
SELECT OBSERVATION_ID,
    PARTY_ID
FROM view_browseparty_obscontrib;
CREATE VIEW view_browseparty_all_count AS
SELECT count(1) AS countallcontrib,
    party_ID
FROM view_browseparty_all
GROUP BY party_ID;
CREATE VIEW view_browseparty_classcontrib_count AS
SELECT count(1) AS countclasscontrib,
    party_ID
FROM view_browseparty_classcontrib
GROUP BY party_ID;
CREATE VIEW view_browseparty_obscontrib_count AS
SELECT count(1) AS countobscontrib,
    party_ID
FROM view_browseparty_obscontrib
GROUP BY party_ID;
CREATE VIEW view_browseparty_projectcontrib_count AS
SELECT count(1) AS countprojectcontrib,
    party_ID
FROM view_browseparty_projectcontrib
GROUP BY party_ID;
CREATE VIEW view_browseparty_all_count_combined AS
SELECT view_browseparty_all_count.party_ID,
    view_browseparty_all_count.countallcontrib,
    view_browseparty_classcontrib_count.countclasscontrib,
    view_browseparty_obscontrib_count.countobscontrib,
    view_browseparty_projectcontrib_count.countprojectcontrib
FROM (
        (
            view_browseparty_all_count
            LEFT JOIN view_browseparty_classcontrib_count ON view_browseparty_all_count.party_ID = view_browseparty_classcontrib_count.party_ID
        )
        LEFT JOIN view_browseparty_obscontrib_count ON view_browseparty_all_count.party_ID = view_browseparty_obscontrib_count.party_ID
    )
    LEFT JOIN view_browseparty_projectcontrib_count ON view_browseparty_all_count.party_ID = view_browseparty_projectcontrib_count.party_ID
ORDER BY countallcontrib DESC;
CREATE view view_csv_taxonimportance_pre AS
SELECT taxonobservation.observation_id AS observation_ID,
    authorplantname AS plant,
    (
        CASE
            WHEN (taxonimportance.stratum_id is null) THEN '-all-'
            ELSE (
                SELECT stratumtype.stratumname
                FROM stratumtype,
                    stratum
                WHERE stratum.stratumtype_id = stratumtype.stratumtype_id
                    AND stratum.stratum_id = taxonimportance.stratum_id
            )
        END
    ) AS stratum,
    cover,
    (
        select min(coverIndex.coverCode)
        from coverIndex
        where coverPercent = taxonimportance.cover
            AND coverIndex.coverMethod_ID = observation.coverMethod_ID
            and observation.observation_ID = taxonobservation.observation_ID
    ) as coverCode_exact,
    (
        select min(coverIndex.coverCode)
        from coverIndex
        where upperlimit >= taxonimportance.cover
            and lowerlimit <= taxonimportance.cover
            AND coverIndex.coverMethod_ID = observation.coverMethod_ID
            and observation.observation_ID = taxonobservation.observation_ID
    ) as coverCode_byrange,
    taxonimportance.basalarea,
    taxonobservation.accessioncode
FROM taxonobservation,
    taxonimportance,
    view_notemb_observation AS observation
WHERE taxonobservation.taxonobservation_id = taxonimportance.taxonobservation_id
    AND taxonobservation.observation_ID = observation.observation_ID;
CREATE view view_csv_taxonimportance AS
SELECT observation_ID,
    plant,
    stratum,
    cover,
    CASE
        WHEN (covercode_exact is null) THEN covercode_byrange
        ELSE covercode_exact
    END as covercode,
    basalarea,
    accessioncode
FROM view_csv_taxonimportance_pre;
-- the following views create "standard" names for plantconcepts, based on usages of preferred party and classsystems: 
DROP VIEW IF EXISTS view_std_plantnames_code;
CREATE VIEW view_std_plantnames_code AS
SELECT plantconcept_id,
    plantname
FROM plantusage
WHERE classsystem = 'Code'
    AND party_id = (
        SELECT party_id
        FROM party
        WHERE accessioncode = 'VB.Py.511.USDANRCSPLANTS2'
    )
    AND usagestop IS NULL;
DROP VIEW IF EXISTS view_std_plantnames_sciname;
CREATE VIEW view_std_plantnames_sciname AS
SELECT plantconcept_id,
    plantname
FROM plantusage
WHERE classsystem = 'Scientific'
    AND party_id = (
        SELECT party_id
        FROM party
        WHERE accessioncode = 'VB.Py.511.USDANRCSPLANTS2'
    )
    AND usagestop IS NULL;
DROP VIEW IF EXISTS view_std_plantnames_scinamenoauth;
CREATE VIEW view_std_plantnames_scinamenoauth AS
SELECT plantconcept_id,
    plantname
FROM plantusage
WHERE classsystem = 'Scientific without authors'
    AND party_id = (
        SELECT party_id
        FROM party
        WHERE accessioncode = 'VB.Py.511.USDANRCSPLANTS2'
    )
    AND usagestop IS NULL;
DROP VIEW IF EXISTS view_std_plantnames_common;
CREATE VIEW view_std_plantnames_common AS
SELECT plantconcept_id,
    plantname
FROM plantusage
WHERE classsystem = 'English Common'
    AND party_id = (
        SELECT party_id
        FROM party
        WHERE accessioncode = 'VB.Py.511.USDANRCSPLANTS2'
    )
    AND usagestop IS NULL;
--the following views are same as above, but not party specific, to catch "other concepts":   
DROP VIEW IF EXISTS view_all_plantnames_code;
CREATE VIEW view_all_plantnames_code AS
SELECT plantconcept_id,
    plantname
FROM plantusage
WHERE classsystem = 'Code';
DROP VIEW IF EXISTS view_all_plantnames_sciname;
CREATE VIEW view_all_plantnames_sciname AS
SELECT plantconcept_id,
    plantname
FROM plantusage
WHERE classsystem = 'Scientific';
DROP VIEW IF EXISTS view_all_plantnames_scinamenoauth;
CREATE VIEW view_all_plantnames_scinamenoauth AS
SELECT plantconcept_id,
    plantname
FROM plantusage
WHERE classsystem = 'Scientific without authors';
DROP VIEW IF EXISTS view_all_plantnames_common;
CREATE VIEW view_all_plantnames_common AS
SELECT plantconcept_id,
    plantname
FROM plantusage
WHERE classsystem = 'English Common';
-- the following views create "standard" names for commconcepts, based on usages of preferred party and classsystems: 
DROP VIEW IF EXISTS view_std_commnames_code;
CREATE VIEW view_std_commnames_code AS
SELECT commconcept_id,
    commname
FROM commusage
WHERE classsystem = 'Code'
    AND party_id = (
        SELECT party_id
        FROM party
        WHERE accessioncode = 'VB.Py.512.NATURESERVE'
    )
    AND usagestop IS NULL;
DROP VIEW IF EXISTS view_std_commnames_sciname;
CREATE VIEW view_std_commnames_sciname AS
SELECT commconcept_id,
    commname
FROM commusage
WHERE classsystem = 'Scientific'
    AND party_id = (
        SELECT party_id
        FROM party
        WHERE accessioncode = 'VB.Py.512.NATURESERVE'
    )
    AND usagestop IS NULL;
DROP VIEW IF EXISTS view_std_commnames_translated;
CREATE VIEW view_std_commnames_translated AS
SELECT commconcept_id,
    commname
FROM commusage
WHERE classsystem = 'Translated'
    AND party_id = (
        SELECT party_id
        FROM party
        WHERE accessioncode = 'VB.Py.512.NATURESERVE'
    )
    AND usagestop IS NULL;
DROP VIEW IF EXISTS view_std_commnames_common;
CREATE VIEW view_std_commnames_common AS
SELECT commconcept_id,
    commname
FROM commusage
WHERE classsystem = 'Common'
    AND party_id = (
        SELECT party_id
        FROM party
        WHERE accessioncode = 'VB.Py.512.NATURESERVE'
    )
    AND usagestop IS NULL;
DROP VIEW IF EXISTS view_all_commnames_code;
CREATE VIEW view_all_commnames_code AS
SELECT commconcept_id,
    commname
FROM commusage
WHERE classsystem = 'Code';
DROP VIEW IF EXISTS view_all_commnames_sciname;
CREATE VIEW view_all_commnames_sciname AS
SELECT commconcept_id,
    commname
FROM commusage
WHERE classsystem = 'Scientific';
DROP VIEW IF EXISTS view_all_commnames_translated;
CREATE VIEW view_all_commnames_translated AS
SELECT commconcept_id,
    commname
FROM commusage
WHERE classsystem = 'Translated';
DROP VIEW IF EXISTS view_all_commnames_common;
CREATE VIEW view_all_commnames_common AS
SELECT commconcept_id,
    commname
FROM commusage
WHERE classsystem = 'Common';
CREATE VIEW view_comminterp_more AS
SELECT commClass.observation_ID,
    inspection,
    tableanalysis,
    multivariateanalysis,
    expertsystem,
    classpublication_id,
    classnotes,
    accessioncode,
    classstartdate,
    classstopdate,
    comminterpretation.*,
    (
        CASE
            WHEN classfit = 'Absolutely wrong' THEN 6
            WHEN classfit = 'Understandable but wrong' THEN 4
            WHEN classfit = 'Reasonable or acceptable answer' THEN 3
            WHEN classfit = 'Good answer' THEN 2
            WHEN classfit = 'Absolutely correct' THEN 1
            ELSE 5
        END
    ) as classfitnum,
    (
        CASE
            WHEN classconfidence = 'High' THEN 1
            WHEN classconfidence = 'Medium' THEN 2
            WHEN classconfidence = 'Low' THEN 3
            ELSE 4
        END
    ) as classconfidencenum
FROM view_notemb_commClass as commclass,
    comminterpretation
WHERE commclass.commclass_ID = comminterpretation.commclass_ID;
CREATE VIEW view_taxonInterp_more AS
SELECT taxonInterpretation.*,
    plantconcept.accessionCode AS pc_accessioncode,
    plantconcept.plantname as pc_plantname,
    taxonobservation.observation_ID
FROM view_notEmb_taxonInterpretation as taxonInterpretation,
    taxonobservation,
    plantconcept
WHERE taxonobservation.taxonobservation_ID = taxonInterpretation.taxonobservation_ID
    AND plantconcept.plantconcept_id = taxonInterpretation.plantconcept_id;
CREATE VIEW view_observation_transl AS
SELECT observation_ID,
    COALESCE(authorObsCode, authorPlotCode) AS observation_id_transl
FROM view_notemb_observation as observation,
    plot
WHERE observation.plot_ID = plot.plot_ID;
-- CREATE VIEW view_taxonobs_distinctid_curr AS SELECT observation_id, int_currplantconcept_id as plantconcept_id, max(cover) as maxplantcover FROM view_notEmb_taxonObservation as taxonobservation,     taxonimportance where taxonimportance.taxonobservation_id=taxonobservation.taxonobservation_id GROUP BY plantconcept_id,observation_id;
-- this view needed in the event there are no taxonimportance records for a taxonobservation.
-- DROP VIEW IF EXISTS view_taxonobs_withmaxcover;
CREATE VIEW view_taxonobs_withmaxcover AS
SELECT taxonobservation.*,
    (
        select max(cover)
        from taxonimportance
        where taxonimportance.taxonobservation_ID = taxonobservation.taxonobservation_ID
    ) as maxcover
FROM view_notEmb_taxonObservation as taxonobservation;
--   DROP VIEW IF EXISTS view_taxonobs_distinctid_curr;
CREATE VIEW view_taxonobs_distinctid_curr AS
SELECT userdataset_id,
    observation_id,
    int_currplantconcept_id as plantconcept_id,
    max(maxcover) as maxplantcover
FROM view_taxonobs_withmaxcover as taxonobservation,
    userdatasetitem
WHERE observation_id = itemrecord
    AND itemtable = 'observation'
GROUP BY plantconcept_id,
    userdataset_id,
    observation_id;
-- DROP VIEW IF EXISTS view_taxonobs_distinctid_curr_counts;  
CREATE VIEW view_taxonobs_distinctid_curr_counts AS
SELECT userdataset_id,
    plantconcept_id,
    count(1) AS countObs,
    avg(maxplantcover) AS avgcovernoround,
    min(maxplantcover) AS mincovernoround,
    max(maxplantcover) AS maxcovernoround
FROM view_taxonobs_distinctid_curr
GROUP BY userdataset_id,
    plantconcept_id;
-- DROP VIEW IF EXISTS view_taxonobs_distinctid_curr_counts_plants;
CREATE VIEW view_taxonobs_distinctid_curr_counts_plants AS
SELECT view_taxonobs_distinctid_curr_counts.*,
    round(
        CAST (
            view_taxonobs_distinctid_curr_counts.avgcovernoround as numeric
        ),
        3
    ) AS avgcover,
    round(
        CAST (
            view_taxonobs_distinctid_curr_counts.mincovernoround as numeric
        ),
        3
    ) AS mincover,
    round(
        CAST (
            view_taxonobs_distinctid_curr_counts.maxcovernoround as numeric
        ),
        3
    ) AS maxcover,
    temptbl_std_plantnames.plantname,
    temptbl_std_plantnames.sciname,
    temptbl_std_plantnames.scinamenoauth,
    temptbl_std_plantnames.code,
    temptbl_std_plantnames.common
FROM temptbl_std_plantnames,
    view_taxonobs_distinctid_curr_counts
WHERE view_taxonobs_distinctid_curr_counts.plantconcept_ID = temptbl_std_plantnames.plantconcept_ID;
--DROP VIEW IF EXISTS view_plotall_withembargo;
CREATE VIEW view_plotall_withembargo AS
SELECT plot.*,
    embargo_id,
    embargoreason,
    defaultstatus,
    embargostart,
    embargostop,
    (
        defaultstatus + CASE
            WHEN embargostop < now() then 100
            ELSE 0
        END
    ) AS embstatusinclexpired
from plot
    LEFT JOIN embargo on plot.plot_id = embargo.plot_ID;
--CREATE VIEW view_taxonobs_distinctid_orig;
-- KEYWORDS VIEWS (otherwise they just aren't robust enough and are breaking!)
CREATE VIEW view_kwhelper_refjournal AS
SELECT reference.reference_id,
    coalesce(referencejournal.journal, '') || ' ' || coalesce(referencejournal.issn, '') || ' ' || coalesce(referencejournal.abbreviation, '') as kw
FROM reference,
    referencejournal
WHERE reference.referencejournal_id = referencejournal.referencejournal_id
GROUP BY reference.reference_id,
    referencejournal.journal,
    referencejournal.issn,
    referencejournal.abbreviation;
CREATE VIEW view_kwhelper_refparty AS
SELECT reference.reference_id,
    public.CONCAT(
        ' ' || coalesce(referenceparty.givenname, '') || ' ' || coalesce(referenceparty.surname, '') || ' ' || coalesce(referenceparty.suffix, '') || ' ' || coalesce(referenceparty.organizationname, '')
    ) as kw
FROM referenceparty,
    reference,
    referencecontributor
WHERE referencecontributor.referenceparty_id = referenceparty.referenceparty_id
    AND reference.reference_id = referencecontributor.reference_id
GROUP BY reference.reference_id;
CREATE VIEW view_keywProjPlaces AS
SELECT project.project_id,
    plot.stateProvince
FROM plot,
    project,
    observation
WHERE plot.plot_ID = observation.plot_ID
    AND project.project_id = observation.project_id
GROUP BY project.project_ID,
    plot.stateProvince;
CREATE VIEW view_kwhelper_projcontrib AS
SELECT project.project_id,
    public.CONCAT(
        ' ' || coalesce(party.givenname, '') || ' ' || coalesce(party.surname, '')
    ) as kw
FROM party,
    project,
    projectcontributor
WHERE party.party_id = projectcontributor.party_Id
    AND project.project_id = projectcontributor.project_id
GROUP BY project.project_id;
CREATE VIEW view_dbafielddesc_notimpl AS
SELECT dba_fielddescription_id,
    tablename,
    (
        SELECT tablelabel
        from dba_tabledescription
        WHERE dba_fielddescription.tablename = dba_tabledescription.tableName
        LIMIT 1
    ) AS tablename_transl,
    fieldname,
    fieldlabel,
    fieldmodel,
    fieldnulls,
    (
        CASE
            when fieldnulls = 'no' THEN 'required'
            ELSE 'no'
        END
    ) as fieldnulls_transl,
    fieldtype,
    fieldkey,
    (
        CASE
            WHEN fieldkey = 'PK' THEN fieldkey
            WHEN fieldkey = 'FK' THEN fieldkey
            WHEN fieldmodel = 'denorm' THEN fieldmodel
            WHEN fieldmodel = 'implementation' THEN fieldmodel
            ELSE 'n/a'
        END
    ) as fieldkey_transl,
    fieldreferences,
    fieldlist,
    fieldnotes,
    fielddefinition,
    fieldkeywords
FROM dba_fielddescription
WHERE lower(fieldmodel) <> 'implementation'
    and lower(fieldmodel) <> 'denorm'
ORDER BY dba_fielddescription_id;
create view stratumtype_x_stratummethod AS
select stratumType.*,
    stratumMethod.accessionCode as sm_accCode
from stratumType
    inner join stratummethod on stratumType.stratummethod_id = stratummethod.stratummethod_id;
create view stratumtype_x_observation AS
SELECT stratum.stratum_id,
    stratum.stratumname,
    observation.accessioncode
FROM observation
    JOIN stratum ON observation.observation_id = stratum.observation_id;