from operators import table_defs_config
from utilities import validate_required_and_missing_fields
config = {
    # Defines the required fields and table defs for each file that vegbank uploads. 
    # Note: plot observations don't appear here because they have nonstandard requirements.
    # See the validate_plot_observations method for more. 
    "projects":{
        "required_fields":['project_name', 'user_pj_code'],
        "table_defs":[table_defs_config.project]
    },
    "plot_observations":{}

}
def validate(df, file_name):
    if file_name not in config:
        return {
            "has_error": False,
            "error": ""
        }
    if file_name == "plot_observations":
        return validate_plot_observations(df)
    return validate_required_and_missing_fields(df, config[file_name]['required_fields'], config[file_name]['table_defs'], file_name)

def validate_plot_observations(df):
    if 'user_pl_code' not in df.columns:
        df['user_pl_code'] = None
    if 'vb_pl_code' not in df.columns:
        df['vb_pl_code'] = None

    validation = {
        'error': "",
        'has_error': False
    }
    
    if not df[(df['user_pl_code'].notnull()) & (df['vb_pl_code'].notnull())].empty:
        validation['error'] += "Rows cannot have both a vb_pl_code and a user_pl_code. For new plots, use user_pl_code. To reference existing plots, use vb_pl_code."
        validation['has_error'] = True
    if not df[(df['user_pl_code'].isnull()) & (df['vb_pl_code'].isnull())].empty:
        validation['error'] += "All rows must have either a vb_pl_code or a user_pl_code. For new plots, use user_pl_code. To reference existing plots, use vb_pl_code."
        validation['has_error'] = True
    
    new_plots_df = df[df['user_pl_code'].notnull() & df['vb_pl_code'].isnull()] 
    old_plots_df = df[df['user_pl_code'].isnull() & df['vb_pl_code'].notnull()] 

    table_defs = [table_defs_config.plot, table_defs_config.observation]
    new_pl_required_fields = ['user_pl_code', 'author_plot_code', 'real_latitude', 'real_longitude', 'confidentiality_status', 'latitude', 'longitude', 'user_ob_code', 'vb_pj_code']
    old_pl_required_fields = ['vb_pl_code', 'user_ob_code', 'vb_pj_code']
    new_validation = validate_required_and_missing_fields(new_plots_df, new_pl_required_fields, table_defs, "observations on new plots")
    old_validation = validate_required_and_missing_fields(old_plots_df, old_pl_required_fields, table_defs, "observations on existing plots")

    validation['error'] += new_validation['error'] + old_validation['error']
    validation['has_error'] = new_validation['has_error'] or old_validation['has_error'] or validation['has_error']
    return validation