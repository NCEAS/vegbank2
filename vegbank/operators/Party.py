import os
from operators import Operator
from utilities import QueryParameterError


class Party(Operator):
    """
    Defines operations related to the exchange of party (people) data with
    VegBank.

    Party: A person or organization associated with the collection or
        management of vegetation data.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "party"
        self.table_code = "py"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.sort_options = ["default", "surname", "organization_name", "obs_count"]

    def configure_query(self, *args, **kwargs):
        base_columns = {'*': "*"}
        base_columns_search = {
            'search_rank': "TS_RANK(py.search_vector, " +
                           "WEBSEARCH_TO_TSQUERY('simple', %s))"
        }
        main_columns = {}
        main_columns['full'] = {
            'py_code': "'py.' || py.party_id",
            'party_label': "pyt.party_id_transl",
            'salutation': "py.salutation",
            'given_name': "py.givenname",
            'middle_name': "py.middlename",
            'surname': "py.surname",
            'organization_name': "py.organizationname",
            'contact_instructions': "py.contactinstructions",
            'obs_count': "d_obscount",
        }
        from_sql = """\
            FROM py
            LEFT JOIN view_party_transl pyt USING (party_id)
            """
        order_by_sql = {}
        order_by_sql['default'] = f"""\
            ORDER BY party_id {self.direction}
            """
        order_by_sql['surname'] = f"""\
            ORDER BY surname {self.direction},
                     party_id {self.direction}
            """
        order_by_sql['organization_name'] = f"""\
            ORDER BY organizationname {self.direction},
                     party_id {self.direction}
            """
        order_by_sql['obs_count'] = f"""\
            ORDER BY d_obscount {self.direction},
                     party_id {self.direction}
            """

        self.query = {}
        self.query['base'] = {
            'alias': "py",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
                'search': {
                    'columns': base_columns_search,
                    'params': ['search']
                },
            },
            'from': {
                'sql': "FROM party AS py",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': "partypublic IS NOT false",
                    'params': []
                },
                'search': {
                    'sql': """\
                         py.search_vector @@ WEBSEARCH_TO_TSQUERY('simple', %s)
                    """,
                    'params': ['search']
                },
                "py": {
                    'sql': "py.party_id = %s",
                    'params': ['vb_id']
                },
                'cl': {
                    'sql': """\
                        EXISTS (
                            SELECT clc.party_id
                              FROM classcontributor clc
                              WHERE py.party_id = clc.party_id
                                AND clc.commclass_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'ob': {
                    'sql': """\
                        EXISTS (
                            SELECT obp.party_id
                              FROM observationcontributor obp
                              WHERE py.party_id = obp.party_id
                                AND obp.observation_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'pj': {
                    'sql': """\
                        EXISTS (
                            SELECT pjc.party_id
                              FROM projectcontributor pjc
                              WHERE py.party_id = pjc.party_id
                                AND pjc.project_id = %s)
                        """,
                    'params': ['vb_id']
                },
            },
            'order_by': {
                'sql': order_by_sql[self.order_by],
                'params': []
            },
        }
        self.query['select'] = {
            "always": {
                'columns': main_columns[self.detail],
                'params': []
            },
            'search': {
                'columns': {'search_rank': 'py.search_rank'},
                'params': []
            },
        }
        self.query['from'] = {
            'sql': from_sql,
            'params': []
        }

    def validate_query_params(self, request_args):
        """
        Validate query parameters and apply defaults to missing parameters.

        This only applies validations specific to parties, while dispatching
        to the parent validation method for common validations.

        Parameters:
            request_args (ImmutableMultiDict): Query parameters provided
                as part of the request.

        Returns:
            dict: A dictionary of validated parameters with defaults applied.

        Raises:
            QueryParameterError: If any supplied parameters are invalid.
        """
        # dispatch to the base validation method
        params = super().validate_query_params(request_args)

        # capture search parameter, if it exists
        params['search'] = request_args.get('search')

        return params
