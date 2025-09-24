class Operator:
    '''
    A super class for all operators to inherit from and define common default values.
    Attributes: 
        QUERIES_FOLDER: str: The folder path where SQL query files are stored.
        default_detail: str: The default detail level for responses, set to "full".
        default_limit: str: The default limit for number of records to return, set to "1000".
        default_offset: str: The default offset for number of records to skip, set to "0".
    '''

    
    def __init__(self):
        '''
        Initialize common default values for all operators.
        '''
        self.QUERIES_FOLDER = "queries/"
        self.default_detail = "full"
        self.default_limit = "1000"
        self.default_offset = "0"