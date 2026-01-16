import traceback
import pandas as pd
from operators import (
    PlotObservation, 
    Project, 
    TaxonObservation,
    Party,
    Reference,
    table_defs_config as table_defs
)
from utilities import (
    jsonify_error_message,
    UploadDataError, 
    merge_vb_codes, 
    read_parquet_file, 
    combine_json_return
) 



def bulk_manager_upload(request, conn, params):
    upload_files = {
    'pj': {
        'file_name': 'projects',
        'required': False
    },
    'py': {
        'file_name': 'parties',
        'required': False
    },
    'rf': {
        'file_name': 'references',
        'required': False
    },
    'pl': {
        'file_name': 'plot_observations',
        'required': True
    },
    'sr': {
        'file_name': 'strata',
        'required': False
    },
    'sc': {
        'file_name': 'strata_cover_data',
        'required': False
    },
    'sd': {
        'file_name': 'stem_data',
        'required': False
    },
    'ti': {
        'file_name': 'taxon_interpretations',
        'required': False
    }
}
    data = {}
    for name, config in upload_files.items():
        try:
            data[name] = read_parquet_file(
                request, config['file_name'], required=config['required'])
        except UploadDataError as e:
            return jsonify_error_message(e.message), e.status_code

    to_return = None
    if data['pj'] is not None:
        pjs = Project(params).upload_project(data['pj'], conn)
        to_return = combine_json_return(to_return, pjs)
    if data['py'] is not None:
        pys = Party(params).upload_parties(data['py'], conn)
        to_return = combine_json_return(to_return, pys)
    if data['rf'] is not None:
        rfs = Reference(params).upload_references(data['rf'], conn)
        to_return = combine_json_return(to_return, rfs)

    if data['pl'] is not None:
        if pjs is not None:
            data['pl'] = merge_vb_codes(
                pjs['resources']['pj'], data['pl'],
                {
                    'user_pj_code': 'user_pj_code',
                    'vb_pj_code': 'vb_pj_code'
                }
            )

        pls = PlotObservation(params).upload_plot_observations(data['pl'], conn)
        to_return = combine_json_return(to_return, pls)
    if data['sr'] is not None:
        if pls is not None:
            data['sr'] = merge_vb_codes(
                pls['resources']['ob'], data['sr'],
                {
                    'user_ob_code': 'user_ob_code',
                    'vb_ob_code': 'vb_ob_code'
                }
            )
        srs = TaxonObservation(params).upload_strata_definitions(data['sr'], conn)
        to_return = combine_json_return(to_return, srs)
    if data['sc'] is not None:
        if pls is not None:
            data['sc'] = merge_vb_codes(
                pls['resources']['ob'], data['sc'],
                {
                    'user_ob_code': 'user_ob_code',
                    'vb_ob_code': 'vb_ob_code'
                }
            )
        if srs is not None:
            data['sc'] = merge_vb_codes(
                srs['resources']['sr'], data['sc'],
                {
                    'user_sr_code': 'user_sr_code',
                    'vb_sr_code': 'vb_sr_code'
                }
            )
        scs = TaxonObservation(params).upload_strata_cover_data(data['sc'], conn)
        to_return = combine_json_return(to_return, scs)

    if data['ti'] is not None:
        if rfs is not None:
            data['ti'] = merge_vb_codes(
                rfs['resources']['rf'], data['ti'],
                {
                    'user_rf_code': 'user_rf_code',
                    'vb_rf_code': 'vb_rf_code'
                }
            )
        if pys is not None:
            data['ti'] = merge_vb_codes(
                pys['resources']['py'], data['ti'],
                {
                    'user_py_code': 'user_py_code',
                    'vb_py_code': 'vb_py_code'
                }
            )
        if scs is not None:
            data['ti'] = merge_vb_codes(
                scs['resources']['to'], data['ti'],
                {
                    'user_to_code': 'user_to_code',
                    'vb_to_code': 'vb_to_code'
                }
            )
        tis = TaxonObservation(params).upload_taxon_interpretations(data['ti'], conn)
        to_return = combine_json_return(to_return, tis)
    if data['sd'] is not None:
        if scs is not None:
            data['sd'] = merge_vb_codes(
                scs['resources']['tm'], data['sd'],
                {
                    'user_tm_code': 'user_tm_code',
                    'vb_tm_code': 'vb_tm_code'
                }
            )
        sds = TaxonObservation(params).upload_stem_data(data['sd'], conn)
        to_return = combine_json_return(to_return, sds)
    return to_return               