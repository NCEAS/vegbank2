# Overall application tests that aren't specific to a particular module

def test_import_utilties():
    """Confirm that we can import the utilities module from vegbank"""
    import vegbank.utilities

def test_import_repositories():
    """Confirm that we can import the repositories module from vegbank"""
    import vegbank.repositories

def test_import_operators():
    """Confirm that we can import the operators module from vegbank"""
    import vegbank.operators