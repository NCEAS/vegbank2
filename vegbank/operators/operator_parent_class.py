class Operator:

    
    def __init__(self, request, params, accession_code):
        self.QUERIES_FOLDER = "queries/"
        self.default_detail = "full"
        self.default_limit = "1000"
        self.default_offset = "0"
        self.request = request
        self.params = params
        self.accession_code = accession_code