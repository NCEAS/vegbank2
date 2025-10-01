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
        self.full_get_parameters = ('limit', 'offset')

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
