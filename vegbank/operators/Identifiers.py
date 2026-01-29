class Identifiers:
    """
    Docstring for Identifier - TODO
    """

    def __init__(self, params: dict):
        self.params = params
        # TODO
        # Set a list of all routes to potentially return
        # self.routes = routes

    
    def exists(self):
        """
        Take a given user input that represents an identifier, and determine
        if it exists/can be found in the 'identifiers_value' column
        """
        # TODO
        # Search for the identifier
        # Ex. "SELECT 1 FROM identifiers WHERE id = %s LIMIT 1"
        # TODO Review exact query for efficiency

    
    def resolve(self):
        """
        Attempt to resolve the endpoint for a given identifier
        """
        # TODO Consider where to:
        # - get a list of routes from vegbankapi
        # - suggest what endpoints the user might want to try
        # - if it exists, is it possible to return a basic view