import io
from datetime import datetime, timezone
from types import SimpleNamespace
import zipfile
import pyarrow as pa
import pyarrow.compute as pc
import pyarrow.csv as csv
import adbc_driver_postgresql.dbapi as pg_dbapi
from flask import Response, send_file
from .CommunityConcept import CommunityConcept
from .CommunityInterpretation import CommunityInterpretation
from .Party import Party
from .PlantConcept import PlantConcept
from .PlotObservation import PlotObservation
from .Project import Project
from .StemCount import StemCount
from .Stratum import Stratum
from .TaxonImportance import TaxonImportance
from .TaxonInterpretation import TaxonInterpretation
from .TaxonObservation import TaxonObservation
from vegbank.operators import Operator, table_code_lookup
from vegbank.utilities import (
    create_adbc_uri,
    convert_psycopg_sql_to_adbc,
    jsonify_error_message,
    process_option_param,
    QueryParameterError,
)


class PlotObservationBundle(Operator):
    """
    Defines operations related to the exchange of plot observation data with
    VegBank, including both plot-level and observation-level details.

    Plot: Represents a specific area of land where vegetation data is collected.
    Observation: Represents the data collected from a plot at a specific time,
        including attributes that may change in between different observation events.

    Inherits from the Operator parent class to utilize common default values and
    methods.
    """

    def __init__(self, params):
        super().__init__(params)
        self.name = "plot_observation"
        self.table_code = "ob"
        self.queries_package = f"{self.queries_package}.{self.name}"
        self.default_limit = 20000
        self.max_limit = self.default_limit
        self.record_limit = 100000
        self.sort_options = ("default", "author_obs_code")
        self.bundle_options = ("csv", )
        self.default_bundle = "csv"
        self.temp_table = "bundle"

    def configure_query(self, *args, **kwargs):
        self.query = {}
        self.query['base'] = {
            'alias': "ob",
            'select': {
                "always": {
                    'columns': {'ob.*': "*"},
                    'params': []
                },
                'search': {
                    'columns': {
                        'search_rank': "TS_RANK(ob.search_vector, " +
                            "WEBSEARCH_TO_TSQUERY('simple', %s))"
                    },
                    'params': ['search']
                },
            },
            'from': {
                'sql': "FROM observation AS ob",
                'params': []
            },
            'conditions': {
                'always': {
                    'sql': [
                        "(emb_observation < 6 OR emb_observation IS NULL)",
                    ],
                    'params': []
                },
                'search': {
                    'sql': """\
                         ob.search_vector @@ WEBSEARCH_TO_TSQUERY('simple', %s)
                    """,
                    'params': ['search']
                },
                'ob': {
                    'sql': "ob.observation_id = %s",
                    'params': ['vb_id']
                },
                'ds': {
                    'sql': """\
                        EXISTS (
                            SELECT itemrecord
                              FROM userdataset ud
                              JOIN userdatasetitem udi USING (userdataset_id)
                              WHERE ud.datasetsharing = 'public'
                                AND udi.itemtable = 'observation'
                                AND ob.observation_id = udi.itemrecord
                                AND ud.userdataset_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'cc': {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                              FROM commclass cl
                              JOIN comminterpretation ci USING (commclass_id)
                              JOIN commconcept cc USING (commconcept_id)
                              WHERE ob.observation_id = cl.observation_id
                                AND commconcept_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'np': {
                    'sql': """\
                        EXISTS (
                            SELECT namedplace_id
                              FROM namedplace np
                              JOIN place p USING (namedplace_id)
                              JOIN plot pl USING (plot_id)
                              WHERE ob.plot_id = pl.plot_id
                                AND namedplace_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'pc': {
                    'sql': """\
                        EXISTS (
                            SELECT observation_id
                              FROM taxonobservation txo
                              JOIN taxoninterpretation txi USING (taxonobservation_id)
                              JOIN plantconcept pc USING (plantconcept_id)
                              WHERE ob.observation_id = txo.observation_id
                                AND plantconcept_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'pj': {
                    'sql': "project_id = %s",
                    'params': ['vb_id']
                },
                # This gets *all* contributors, not just observationcontributors
                'py': {
                    'sql': """\
                        EXISTS (
                            SELECT py.observation_id
                             FROM view_browseparty_all py
                             WHERE ob.observation_id = py.observation_id
                               AND py.party_id = %s)
                        """,
                    'params': ['vb_id']
                },
                'cm': {
                    'sql': "covermethod_id = %s",
                    'params': ['vb_id']
                },
                'sm': {
                    'sql': "stratummethod_id = %s",
                    'params': ['vb_id']
                }
            },
            'order_by': {
                'sql': "",
                'params': []
            },
        }
        self.query['select'] = {
            "always": {
                'columns': {'observation_id': "ob.observation_id"},
                'params': []
            },
            'search': {
                'columns': {'search_rank': 'ob.search_rank'},
                'params': []
            },
        }
        self.query['from'] = {
            'sql': "FROM ob",
            'params': []
        }

    def validate_query_params(self, request_args):
        """
        Validate query parameters and apply defaults to missing parameters.

        This applies validations specific to plot observations, while
        dispatching to the parent validation method for more general validation.

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

        # add params for bundle download
        params['bundle'] = process_option_param('bundle',
            request_args.get('bundle', self.default_bundle),
            self.bundle_options)

        # capture search parameter, if it exists
        params['search'] = request_args.get('search')

        # enforce maximum plot observation count
        params['limit'] = min(params['limit'], self.max_limit)

        return params

    def get_vegbank_resources(self, request, vb_code=None):
        """
        Export a zip file of CSVs related to a defined set of plot observations

        If this is a single-resource query with a valid ob_code (i.e., prefix
        `ob.`), returns data from the corresponding plot observation.

        If this is a cross-resource query with a valid vb_code for the scoping
        resource (i.e., prefix matches the table code derived from the query
        scope), returns the collection of plot observations associated with the
        scoping resource, up to a maximum of 20,000.

        If no vb_code is provided, returns a collection of plot observations
        defined by pagination parameters, again up to a maximum of 20,000.

        Parameters:
            request (flask.Request): The Flask request object containing query
                parameters.
            vb_code (str or None): The unique identifier for the plot
                observation being retrieved or for another resource used to
                scope the collection of plot observations being retrieved. If
                None, retrieves all plot observations subject to the limit and
                offset.

        Returns:
            flaskResponse: Flask response object that triggers a file download.
                The downloaded file is a ZIP archive containing CSV files with
                the exported data.

                Response details:
                - Content-Type: application/zip
                - Content-Disposition: attachment
        """
        try:
            params = self.validate_query_params(request.args)
        except QueryParameterError as e:
            return jsonify_error_message(e.message), e.status_code

        # Get the table code associated with the current query scope, which may
        # be different from the table code associated with the target resource
        # (defined by self.table_code).
        #
        # E.g., if the route is '/plot-observations', then the query scope and
        # target resource both use table code 'ob'. However, if the route is
        # `/projects/pj.123/plot-observations`, then the query scope is table
        # code `pj` (a project) even though the target resource is associated
        # with table code 'ob' (observations).
        resource_type = request.path.split('/')[1]
        table_code = table_code_lookup[resource_type]

        # Are we limiting our query of the target resource type (e.g., plot
        # observations) to records associated with a member of some other
        # resource type (e.g., a project)?
        is_cross_resource_query = table_code != self.table_code
        # Are we querying based on some specific vb_code?
        querying_by_code = vb_code is not None
        # Are we paginating? Yes whenever we might be pulling multiple records,
        # which is true except when querying a resource directly by its vb_code
        paginating = is_cross_resource_query or not querying_by_code
        # Are we searching? Yes if asked, unless we're getting a single record,
        # in which case *we will ignore the search condition*
        searching = (params.get('search') is not None) and paginating

        if querying_by_code:
            try:
                vb_id = self.extract_id_from_vb_code(vb_code, table_code)
            except QueryParameterError as e:
                return jsonify_error_message(e.message), e.status_code
            params['vb_id'] = vb_id
            by = table_code
        else:
            by = None

        sql, placeholders = self.build_query(by=by, searching=searching,
                                             paginating=paginating, sort=False)
        data = [params.get(val) for val in placeholders]

        request = SimpleNamespace(
            path='bundle/bundle',
            args={
                'limit': self.record_limit,
            }
        )
        uri = create_adbc_uri(self.params)
        filters = {resource_type: vb_code}
        if is_cross_resource_query or not querying_by_code:
            filters = filters | {
                'search': params.get('search'),
                'limit': params.get('limit', 0),
                'offset': params.get('offset', 0),
                'sort': f"{params.get('sort', 'None')} {params.get('direction')}",
            }
        with pg_dbapi.connect(uri) as conn:
            with conn.cursor() as cur:
                # Query for observations and write observation_ids to temp table
                sql = convert_psycopg_sql_to_adbc(sql)
                cur.execute(sql, data)
            query = {
                'plot_observations': PlotObservation(self.params),
                'community_concepts': CommunityConcept(self.params),
                'community_classifications': CommunityInterpretation(self.params),
                'taxon_observations': TaxonObservation(self.params),
                'plant_concepts': PlantConcept(self.params),
                'taxon_interpretations': TaxonInterpretation(self.params),
                'taxon_importances': TaxonImportance(self.params),
                'stem_counts': StemCount(self.params),
                'strata': Stratum(self.params),
                'projects': Project(self.params),
                'parties': Party(self.params),
            }
            return self._create_zip_response(request, conn, query, filters)

    def _create_zip_response(self, request, conn, query, filters):
        """Create a Flask response containing multiple CSV files in a ZIP archive

        Performs multiple queries, fetches their results as Arrow tables,
        converts them to CSV format, and packages all CSV files into a single
        downloadable ZIP archive with an accompanying README.txt that documents
        the download metadata, file structure, and citation information.

        Args:
            request: Flask request object containing request parameters and
                context to be passed to the operators.
            conn: Database connection object to be used by operators when
                fetching VegBank resources. This connection is passed through
                and shared across queries because they all rely on the same temp
                table created in the initial plot observation query.
            query (dict): Dictionary mapping filenames (without extension) to
                operators. Each operator must have a get_vegbank_resources()
                method. Keys become the base names for CSV files in the ZIP.
                Example: {'plots': plot_operator, 'observations': obs_operator}
            filters (dict): Key-value pairs of filter conditions used to restrict
                the set of plot observations included in the download bundle.

        Returns:
            flask.Response: A Flask response object configured to send the ZIP
                file as an attachment.

        Note:
            - All CSV files are compressed using ZIP_DEFLATED compression
            - Extension types in Arrow tables are automatically converted to standard
              types via _convert_extension_types() before CSV conversion
            - A README.txt file is automatically generated and included in the ZIP
        """
        # Get current timestamp
        timestamp = datetime.now(timezone.utc)

        zip_buffer = io.BytesIO()
        with zipfile.ZipFile(zip_buffer, 'w', zipfile.ZIP_DEFLATED) as zip_file:
            # Add CSV files
            record_count = None
            for name, operator in query.copy().items():
                arrow_tbl = operator.get_vegbank_resources(
                    request, None, conn=conn, use_bundle=True)
                arrow_tbl = self._convert_extension_types(arrow_tbl)
                n_rows = len(arrow_tbl)
                if name == 'plot_observations':
                    record_count = n_rows
                if n_rows == 0:
                    del query[name]
                    continue
                filename = name + '.csv'
                csv_buffer = io.BytesIO()
                csv.write_csv(arrow_tbl, csv_buffer)
                zip_file.writestr(filename, csv_buffer.getvalue())
            # Generate README content
            readme_content = self._generate_readme(request, query, record_count,
                                                   filters, timestamp)
            zip_file.writestr('README.txt', readme_content)

        zip_buffer.seek(0)
        file_ts = timestamp.strftime('%Y%m%d_%H%M%S')
        filename = f'vegbank_{self.name}_{timestamp.strftime('%Y%m%d_%H%M%S')}.zip'
        return send_file(
            zip_buffer,
            mimetype='application/zip',
            as_attachment=True,
            download_name=filename
        )

    def _convert_extension_types(self, table):
        """Convert PostgreSQL extension types to standard Arrow types.

        Processes an Arrow table to replace PostgreSQL-specific extension types
        (opaque types) with standard Arrow types that can be safely serialized
        to formats like CSV and Parquet. Handles special conversion logic for
        numeric extension types.

        Args:
            table (pyarrow.Table): Arrow table potentially containing PostgreSQL
                extension types (e.g., numeric, custom types) that need
                conversion to standard Arrow types for compatibility with export
                formats.

        Returns:
            pyarrow.Table: A new Arrow table with the same data but with all
                extension types converted to standard Arrow types:
                - Numeric extension types → float64 (if conversion succeeds) or
                  string
                - Other extension types → their underlying storage type
                - Standard types → unchanged

        Note:
            Extension types are PostgreSQL-specific data types that Arrow
            represents as OpaqueType with an underlying storage type. This
            function extracts the storage type and optionally converts it to a
            more appropriate Arrow type:
            - For 'numeric' types: Attempts to convert to float64 for better
              usability in analytics. Falls back to string if the conversion
              fails (e.g., values exceed float64 range or contain special
              values).
            - For other extension types: Simply uses the storage type (often
              string).
            - Non-extension types: Passed through unchanged.
        """
        new_schema = []
        new_columns = []

        for i, field in enumerate(table.schema):
            col = table.column(i)

            # Check if this is an extension type
            if isinstance(field.type, pa.OpaqueType):
                # Get the storage type
                storage_type = field.type.storage_type

                # Cast to the storage type (usually string for numeric)
                # Then optionally convert to a more appropriate type
                if 'numeric' in str(field.type).lower():
                    # Try to convert to double, fall back to string if it fails
                    try:
                        # First cast to storage type (string), then to double
                        col = pc.cast(col, storage_type)
                        col = pc.cast(col, pa.float64())
                        new_field = pa.field(field.name, pa.float64())
                    except:
                        # If conversion fails, keep as string
                        col = pc.cast(col, storage_type)
                        new_field = pa.field(field.name, storage_type)
                else:
                    # For other extension types, just use the storage type
                    col = pc.cast(col, storage_type)
                    new_field = pa.field(field.name, storage_type)

                new_schema.append(new_field)
                new_columns.append(col)
            else:
                # Not an extension type, keep as-is
                new_schema.append(field)
                new_columns.append(col)

        return pa.table(new_columns, schema=pa.schema(new_schema))

    def _generate_readme(self, request, query, record_count, filters, timestamp):
        """Generate README.txt content for VegBank data download ZIP file.

        Creates formatted documentation that includes download timestamp, source URL,
        record count, applied filters, file structure description, example usage code,
        and proper citation information.

        Args:
            request: Flask request object used to extract filter parameters from the
                URL path and query string to document what filters were applied.
            query (dict): Dictionary mapping CSV filenames to operators, used to
                generate the file structure documentation. The order of items
                determines the order listed in the README.
            record_count (int, optional): Number of records in the primary dataset.
                If provided, included in the README header and citation. If None,
                the "Records:" line is omitted.
            filters (dict): Key-value pairs of filter conditions used to restrict
                the set of plot observations included in the download bundle.
            timestamp (datetime): Recorded time for the download operation.

        Returns:
            str: Formatted README content as a multi-line string ready to be written
                to README.txt in the ZIP archive.

        Note:
            The README includes:
            - Header with timestamp, source, and record count
            - Resource filter description based on request URL and parameters
            - File structure list with descriptions
            - Proper VegBank citation with search timestamp
        """
        # Extract filter information
        display_filters = []
        for filter, value in filters.items():
            if value is None or (filter == 'offset' and value == 0):
                continue
            display_filters.append(f"{filter} = '{value}'")
        filter_desc = ", ".join(display_filters) if display_filters else "none"

        # Build file structure description
        file_descriptions = self._build_file_descriptions(query)

        # Build README content
        readme_parts = [
            "VegBank Data Download",
            "=" * 21,
            "",
            f"Downloaded: {timestamp.strftime('%Y-%m-%d %H:%M:%S %Z')}",
            "Source: https://vegbank.org",
            "",
            f"Plot observation filter: {filter_desc}",
            "",
        ]

        if 0 < record_count:
            readme_parts.append(f"Number of plot observations: {record_count}")
        else:
            readme_parts.append("No plots found!")
            return "\n".join(readme_parts)

        readme_parts.extend([
            "",
            "File structure",
            "-" * 14,
            "",
            "This download contains one or more related CSV files:",
            "",
        ])

        readme_parts.extend(file_descriptions)

        readme_parts.extend([
            "",
            "Important notes:",
            (" - Plot observations are limited to a maximum of "
             f"{filters.get('limit', self.default_limit):,} records."),
            f" - All other CSVs are limited to a maximum of {self.record_limit:,} records.",
            " - The obs_count column in various tables reports *total* plot observation",
            "   counts in VegBank, not counts specific to downloaded data.",
            "",
        ])

        readme_parts.extend([
            "",
            "Citation",
            "-" * 8,
            "Peet, R.K., M.T. Lee, M.D. Jennings, D. Faber-Langendoen (eds). 2013.",
            "VegBank: The vegetation plot archive of the Ecological Society of America.",
            f"http://vegbank.org, searched on {timestamp.strftime('%Y-%m-%d')}",
            ""
        ])

        return "\n".join(readme_parts)


    def _build_file_descriptions(self, query):
        """Generate file structure description list for README.

        Creates a bulleted list describing each CSV file in the download,
        including the filename and a human-readable description of its contents.

        Args:
            query (dict): Dictionary mapping filenames to operators. The
                filenames are used to generate appropriate descriptions.

        Returns:
            list: List of strings, each describing one file in the format:
                "- filename.csv: Description (linked by ob_code)"

        Note:
            File descriptions are generated based on common naming conventions.
            The 'plot_observations.csv' file is treated specially as the primary
            dataset.
        """
        descriptions = []

        # Map common filenames to descriptions
        file_desc_map = {
            'plot_observations': (
                'Plot observations, with `ob_code` as the primary key uniquely identifying\n'
                '  each observation.'
            ),
            'community_concepts': (
                'Community concepts, with `cc_code` as the primary key uniquely identifying\n'
                '  each concept. Can be joined to plot_observations via community_classifications\n'
                '  (see below).'
            ),
            'community_classifications': (
                'Community classifications, with `ci_code` as the primary key uniquely\n'
                '  identifying each community interpretation event. There may be multiple\n'
                '  interpretations per classification event (`cl_code`). Can be joined to\n'
                '  plot_observations (via `ob_code`) and community_concepts (via `cc_code`).'
            ),
            'taxon_observations': (
                'Plant taxa observed on a plot, with `to_code` as the primary key uniquely\n'
                '  identifying each taxon observation. Can be joined to plot_observations\n'
                '  (via `ob_code`).'
            ),
            'plant_concepts': (
                'Plant concepts, with `pc_code` as the primary key uniquely identifying\n'
                '  each concept. Can be joined to plot_observations via taxon_interpretations\n'
                '  (see below).'
            ),
            'taxon_interpretations': (
                'Assignments of plant concepts to taxon observations, with `ti_code` as the\n'
                '  primary key uniquely identifying each interpretation. Can be joined to\n'
                '  plot_observations (via `ob_code`), taxon observations (via `to_code`),\n'
                '  and plant concepts (via `pc_code`).'
            ),
            'taxon_importances': (
                'Plant cover and other metrics recorded for a taxon observation (possibly\n'
                '  limited to a defined stratum), with `tm_code` as the primary key uniquely\n'
                '  identifying each importance record. Can be joined to plot_observations\n'
                '  (via `ob_code`), taxon_observations (via `to_code`), and strata (via\n'
                '  `sr_code`).'
            ),
            'stem_counts': (
                'Counts of stems associated with a given importance record for a taxon\n'
                '  observation (possibly within a defined stratum), with `sc_code` as the\n'
                '  primary key uniquely identifying each stem count. Can be joined to\n'
                '  plot_observations (via `ob_code`), taxon_observations (via `to_code`),\n'
                '  taxon_importances (via `tm_code`), and strata (via `sr_code`).'
            ),
            'strata': (
                'Defined strata in which taxon importances and stem counts may be recorded\n'
                '  as part of a plot observation, with `sr_code` as the primary key uniquely\n'
                '  identifying each stratum. Can be joined to plot_observations (via `ob_code`).'
            ),
            'projects': (
                'Projects under which plot observations were made, with `pj_code` as the\n'
                '  primary key uniquely identifying each project. Can be joined from\n'
                '  plot_observations (via `pj_code`).'
            ),
            'parties': (
                'People and/or organizations contributing to plot observations and related\n'
                '  activities, with `py_code` as the primary key uniquely identifying each\n'
                '  party.'
            ),
        }

        for filename in query.keys():
            desc = file_desc_map.get(filename)
            descriptions.append(f"{filename}.csv")
            descriptions.append(f"- {desc}\n")

        return descriptions
