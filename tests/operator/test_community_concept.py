"""Test module for the 'CommunityConcept' operator class"""
from unittest.mock import MagicMock, patch
import pandas as pd
from vegbank.operators import (
    Operator,
    CommunityConcept,
)
from vegbank.utilities import merge_vb_codes

params = {}

def test_queries_package_attribute():
    """Check that the queries package attribute was overridden as expected."""
    comm_concept_operator = CommunityConcept(params)
    assert (
        comm_concept_operator.queries_package
        == "vegbank.queries.community_concept"
    )


def test_queries_package_override_community_names_v2():
    """Check that the queries package attribute was overridden as expected when calling
    the 'upload_community_names' function."""
    comm_concept_operator = CommunityConcept(params)
    # Create a basic dataframe with the required keys
    df = pd.DataFrame([
        {
            "user_cc_code": "VB.CC.DM.001",
            "vb_cc_code": "test.dm.cc.1",
            "name": "dou.test",
            "name_type": "dou.string",
            "name_status": "name.status",
        }
    ])
    # This connection represents access to a db
    conn = MagicMock()

    # Mock return values for 'upload_to_table'
    cn_actions = {
        "resources": {
            "cn": {
                "user_cn_code": ["dou.test"],
                "vb_cn_code": ["VB.CN.001"],
            }
        },
        "counts": {"cn": 1},
    }
    cu_actions = {
        "resources": {"cu": []},
        "counts": {"cu": 0},
    }

    # Side effect allows the initial call to return the first object,
    # then the subsequent to call the second object
    with patch.object(
        Operator, "upload_to_table", side_effect=[cn_actions, cu_actions]
    ) as _mocked:
        comm_concept_operator.upload_community_names(df, conn)

    assert comm_concept_operator.queries_package == "vegbank.queries.community_name"
