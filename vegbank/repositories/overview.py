from psycopg import connect
from psycopg.rows import dict_row


class Overview:
    """
    Query class for VegBank stats

    This class encapsulates a set SQL queries for producing summary
    stats that provided a basic overview of what's currently in VegBank.
    """

    def __init__(self, params: dict):
        """
        Initialize the query class with database connection parameters.

        Parameters:
            params (dict): Parameters used to connect to the VegBank PostgreSQL
                database (e.g., dbname, user, host, port, password).
        """
        self.params = params


    def get_summary_stats(self, request):
        """
        Return various VegBank resource counts

        Parameters:
            request (flask.Request): The Flask request object containing query
                parameters

        Returns:
            dict: Summary statistics with the following keys:
                - core_counts (list): High level resource counts
                - top_n_community_concepts (list): Top N community concepts by obs count
                - top_n_plant_concepts (list): Top N plant concepts by obs count
                - top_n_projects (list): Top N projects by obs count
                - top_n_contributors (list): Top N contributors by contribution count
                - top_n_named_places (list): Top N named places by obs count
        """
        #TODO: move param validation from Operator to utilities, and use it here
        limit = request.args.get('limit', 5)

        with connect(**self.params, row_factory=dict_row) as conn:
            with conn.cursor() as cur:
                # 1: Top N places by obs count
                cur.execute(
                    """
                    SELECT placename AS name,
                           'np.' || namedplace_id AS np_code,
                           COALESCE(d_obscount, 0) AS count
                      FROM namedplace
                      WHERE placesystem = 'region|state|province'
                      ORDER BY COALESCE(d_obscount, 0) DESC
                      LIMIT %s
                    """, [limit])
                named_places = cur.fetchall()

                # 2: Top N parties by contribution count
                cur.execute(
                    """
                    SELECT party_id_transl AS name,
                           'py.' || party_id AS py_code,
                           COALESCE(countallcontrib, 0) AS count
                      FROM view_browseparty_all_count
                      JOIN view_party_transl USING (party_id)
                      ORDER BY countallcontrib DESC
                      LIMIT %s;
                    """, [limit])
                contributors = cur.fetchall()

                # 3: Top N projects by obs count
                cur.execute(
                    """
                    SELECT projectname AS name,
                           'pj.' || project_id AS pj_code,
                           COALESCE(d_obscount, 0) AS count
                      FROM project
                      ORDER BY COALESCE(d_obscount, 0) DESC
                      LIMIT %s
                    """, [limit])
                projects = cur.fetchall()

                # 4: Top N plant concepts by obs count
                cur.execute(
                    """
                    SELECT plantname AS name,
                           'pc.' || plantconcept_id AS pc_code,
                           COALESCE(d_obscount, 0) AS count
                      FROM plantconcept
                      ORDER BY COALESCE(d_obscount, 0) DESC
                      LIMIT %s
                    """, [limit])
                plant_concepts = cur.fetchall()

                # 5: Top N community concepts by obs count
                cur.execute(
                    """
                    SELECT commname AS name,
                           'cc.' || commconcept_id AS cc_code,
                           COALESCE(d_obscount, 0) AS count
                      FROM commconcept
                      ORDER BY COALESCE(d_obscount, 0) DESC
                      LIMIT %s
                    """, [limit])
                community_concepts = cur.fetchall()

                # 6: Overview counts
                cur.execute(
                    """
                    SELECT COUNT(1) AS count
                      FROM observation
                      WHERE emb_observation < 6
                         OR emb_observation IS NULL
                    """)
                n_obs = cur.fetchone()['count']

                cur.execute(
                    """
                    SELECT COUNT(1) AS count
                      FROM observation AS observation
                      WHERE (emb_observation < 6
                             OR emb_observation IS NULL)
                        AND observation_id in (
                            SELECT commclass.observation_id
                              FROM commclass)
                    """)
                n_obs_classified = cur.fetchone()['count']

                cur.execute(
                    """
                    SELECT COUNT(1) AS count
                      FROM observation AS observation
                      WHERE (emb_observation < 6
                             OR emb_observation IS NULL)
                        AND observation_id in (
                            SELECT commclass.observation_id
                              FROM commclass
                              JOIN comminterpretation USING (commclass_id)
                              JOIN commstatus USING (commconcept_id)
                              WHERE party_id = 512
                                AND commconceptstatus = 'accepted'
                                AND stopdate IS NULL)
                    """)
                n_obs_classified_nvc = cur.fetchone()['count']

                cur.execute(
                    """
                    SELECT COUNT(1) AS count
                      FROM plantconcept
                    """)
                n_plants = cur.fetchone()['count']

                cur.execute(
                    """
                    SELECT COUNT(1) AS count
                      FROM plantconcept
                      WHERE plantconcept_id IN (
                        SELECT plantconcept_id
                          FROM plantstatus
                          WHERE party_id = 511
                            AND plantconceptstatus = 'accepted'
                            AND stopdate IS NULL)
                    """)
                n_plants_accepted_usda = cur.fetchone()['count']

                cur.execute(
                    """
                    SELECT COUNT(1) AS count
                      FROM plantconcept
                      WHERE plantconcept_id IN (
                        SELECT plantconcept_id
                          FROM plantstatus
                          WHERE party_id = 511
                            AND plantconceptstatus = 'accepted')
                        AND 1 <= d_obscount
                    """)
                n_plants_accepted_usda_obs = cur.fetchone()['count']

                cur.execute(
                    """
                    SELECT COUNT(1) AS count
                      FROM commconcept
                    """)
                n_comms = cur.fetchone()['count']

                cur.execute(
                    """
                    SELECT COUNT(1) AS count
                      FROM commconcept
                      WHERE commconcept_id IN (
                        SELECT commconcept_id
                          FROM commstatus
                          WHERE party_id = 512
                            AND commconceptstatus = 'accepted'
                            AND stopdate IS NULL)
                    """)
                n_comms_accepted_nvc = cur.fetchone()['count']

                cur.execute(
                    """
                    SELECT COUNT(1) AS count
                      FROM commconcept
                      WHERE commconcept_id IN (
                        SELECT commconcept_id
                          FROM commstatus
                          WHERE party_id = 512
                            AND commconceptstatus = 'accepted')
                        AND 1 <= d_obscount
                    """)
                n_comms_accepted_nvc_obs = cur.fetchone()['count']

                # Build core_counts array
                core_counts = [
                    {'name': 'Observations',
                     'count': n_obs},
                    {'name': 'Classified observations',
                     'count': n_obs_classified},
                    {'name': 'NVC classified observations',
                     'count': n_obs_classified_nvc},
                    {'name': 'Plants',
                     'count': n_plants},
                    {'name': 'Accepted USDA plants',
                     'count': n_plants_accepted_usda},
                    {'name': 'Observed accepted USDA plants',
                     'count': n_plants_accepted_usda_obs},
                    {'name': 'Communities',
                     'count': n_comms},
                    {'name': 'Accepted US NVC communities',
                     'count': n_comms_accepted_nvc},
                    {'name': 'Observed accepted US NVC communities',
                     'count': n_comms_accepted_nvc_obs},
                ]

                # Assemble into single response
                return {
                    'core_counts': core_counts,
                    'top_n_community_concepts': community_concepts,
                    'top_n_plant_concepts': plant_concepts,
                    'top_n_projects': projects,
                    'top_n_contributors': contributors,
                    'top_n_named_places': named_places,
                }
