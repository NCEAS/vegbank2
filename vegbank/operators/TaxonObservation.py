import os
import pandas as pd
import psycopg
from psycopg.rows import dict_row
from psycopg import ClientCursor
import table_defs_config
from operators import Operator
from utilities import QueryParameterError


class TaxonObservation(Operator):
    """
    Defines operations related to the exchange of taxon observation data with
    VegBank, including taxon importance and (some) taxon interpretation details.

    Taxon Observation: A record of a plant observed within a particular plot
        observation.
    Taxon Importance: Information about the importance (i.e. cover, basal area,
        biomass) of a taxon observation. The importance of a taxon observation
        may be recorded not only for the plot as a whole, but also within one or
        more specified strata.
    Taxon Interpretation: The asserted association of a taxon observation with
        a specific plant name and authority. A single taxon observation can have
        multiple taxon interpretations.

    Inherits from the Operator parent class to utilize common default values and
    methods.

    Note that TaxonObservation deviates from the base Operator class in 2 ways:
    1. Skips querying the db for the full record count, because it takes too long
       (self.include_full_count is False)
    2. Uses an extra query parameter `num_taxa` for capping the number of taxa
       returned per plot observation
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "taxon_observation"
        self.table_code = "to"
        self.QUERIES_FOLDER = os.path.join(self.QUERIES_FOLDER, self.name)
        self.default_num_taxa = 5
        self.include_full_count = False
        self.full_get_parameters = ('num_taxa', 'limit', 'offset')

    def validate_query_params(self, request_args):
        """
        Validate query parameters and apply defaults to missing parameters.

        This only applies validations specific to taxon observations, then
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
        # specifically require detail to be "full" for taxon observations
        if request_args.get("detail", self.default_detail) not in ("full"):
            raise QueryParameterError("When provided, 'detail' must be 'full'.")

        # first dispatch to the base validation method
        params = super().validate_query_params(request_args)

        # now validate param specific to this class
        try:
            params['num_taxa'] = int(request_args.get("num_taxa",
                                                      self.default_num_taxa))
        except ValueError:
            raise QueryParameterError(
                "When provided, 'num_taxa' must be a non-negative integer."
            )
        if params['num_taxa'] < 0:
            raise QueryParameterError(
                "When provided, 'num_taxa' must be a non-negative integer."
            )

        return params

    def upload_strata_definitions(self, file):
        """
        takes a parquet file of strata definitions and uploads it to the stratum table.
        Parameters:
            file (FileStorage): The uploaded parquet file containing strata definitions.
        Returns:
            flask.Response: A JSON response indicating success or failure of the upload operation,
                along with the number of new records and the newly created keys. 
        """
        df = pd.read_parquet(file)
        with psycopg.connect(**self.params, cursor_factory=ClientCursor, row_factory=dict_row) as conn:
            return super().upload_to_table("stratum", 'sr', table_defs_config.stratum, df, True, conn)