import os
from operators import Operator
from utilities import QueryParameterError


class CommunityClassification(Operator):
    """
    Defines operations related to the exchange of community classification data
    with VegBank, including community interpretations.

    Community Classification: Information about a classification activity
        leading one or more parties to apply a community concept to a
        plot observation
    Community Interpretation: The assignment of a specific community concept
        to a plot observations

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "community_classification"
        self.table_code = "cl"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.full_get_parameters = ('limit', 'offset')
