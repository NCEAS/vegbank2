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
        self.full_get_parameters = ('limit', 'offset')

    def configure_query(self, *args, **kwargs):
        base_columns = {'*': "*"}
        base_columns_search = {
            'search_rank': "TS_RANK(py.search_vector, " +
                           "WEBSEARCH_TO_TSQUERY('simple', %s))"
        }
        main_columns = {}
        main_columns['full'] = {
            'py_code': "'py.' || py.party_id",
            'salutation': "py.salutation",
            'given_name': "py.givenname",
            'middle_name': "py.middlename",
            'surname': "py.surname",
            'organization_name': "py.organizationname",
            'contact_instructions': "py.contactinstructions",
        }
        from_sql = "FROM py"
        order_by_sql = """\
            ORDER BY COALESCE(surname, organizationname),
                     party_id
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
            },
            'order_by': {
                'sql': order_by_sql,
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
        # specifically require detail to be "full" for parties
        if request_args.get("detail", self.default_detail) not in ("full"):
            raise QueryParameterError("When provided, 'detail' must be 'full'.")

        # dispatch to the base validation method
        params = super().validate_query_params(request_args)

        # capture search parameter, if it exists
        params['search'] = request_args.get('search')

        return params
