import os
from operators import Operator
from utilities import QueryParameterError


class Reference(Operator):
    """
    Defines operations related to the exchange of cited references with VegBank.

    Reference: A cited source of information used within VegBank, e.g.
        as required to define plant and community concepts.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "reference"
        self.table_code = "rf"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)

    def configure_query(self, *args, **kwargs):
        base_columns = {'*': "*"}
        main_columns = {}
        main_columns['full'] = {
            'rf_code': "'rf.' || rf.reference_id",
            'short_name': "rf.shortname",
            'full_citation': "rf.fulltext",
            'reference_type': "rf.referencetype",
            'title': "rf.title",
            'publication_date': "rf.pubdate",
            'total_pages': "rf.totalpages",
            'publisher': "rf.publisher",
            'publication_place': "rf.publicationplace",
            'degree': "rf.degree",
            'isbn': "rf.isbn",
            'url': "rf.url",
            'doi': "rf.doi",
            'journal': "rj.journal",
        }
        from_sql = """\
            FROM rf
            LEFT JOIN referencejournal rj USING (referencejournal_id)
            """
        order_by_sql = """\
            ORDER BY rf.reference_id
            """

        self.query = {}
        self.query['base'] = {
            'alias': "rf",
            'select': {
                "always": {
                    'columns': base_columns,
                    'params': []
                },
            },
            'from': {
                'sql': "FROM reference AS rf",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': None,
                    'params': []
                },
                "rf": {
                    'sql': "rf.reference_id = %s",
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
        }
        self.query['from'] = {
            'sql': from_sql,
            'params': []
        }

    def validate_query_params(self, request_args):
        """
        Validate query parameters and apply defaults to missing parameters.

        This only applies validations specific to references, then
        dispatches to the parent validation method for more general (and more
        permissive) validations.

        Parameters:
            request_args (ImmutableMultiDict): Query parameters provided
                as part of the request.

        Returns:
            dict: A dictionary of validated parameters with defaults applied.

        Raises:
            QueryParameterError: If any supplied parameters are invalid.
        """
        # specifically require detail to be "full" for references
        if request_args.get("detail", self.default_detail) not in ("full"):
            raise QueryParameterError("When provided, 'detail' must be 'full'.")

        # now dispatch to the base validation method
        return super().validate_query_params(request_args)
