import os
from operators import Operator
from utilities import QueryParameterError


class PlantConcept(Operator):
    '''
    Defines operations related to the exchange of plant concept data with
    Vegbank, including usage and status (party perspective) information.

    Plant Concept: A definition of a named plant taxon according to a reference.
    Plant Usages: Particular names associated with a plant concept, and the
    effective dates, status, and system for that name.
    Plant Status: The asserted status of a concept, according to a party
    (a.k.a., a party perspective).

    Inherits from the Operator parent class to utilize common default values and
    methods.
    '''

    def __init__(self, params):
        super().__init__(params)
        self.name = "plant_concept"
        self.table_code = "pc"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.full_get_parameters = ('limit', 'offset')

    def validate_query_params(self, request_args):
        """
        Validate query parameters and apply defaults to missing parameters.

        This applies only validations specific to plant concepts, then
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
        # specifically require detail to be "full" for plant concepts
        if request_args.get("detail", self.default_detail) not in ("full"):
            raise QueryParameterError("When provided, 'detail' must be 'full'.")

        # now dispatch to the base validation method
        return super().validate_query_params(request_args)