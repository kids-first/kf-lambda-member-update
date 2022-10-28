import tests.constants as constants
import mappings
from service import process_event, build_es_client
import pytest
from os import environ

INDICES = [mappings.INDEX_MEMBER, mappings.INDEX_MEMBERS]


@pytest.fixture
def es():
    # SETUP
    es = build_es_client(
        environ.get("es_host", "elasticsearch"),
        environ.get("es_port", "9200"),
        environ.get("es_scheme", "http"),
    )

    if not es.ping():
        pytest.exit(
            "Do you want to perform a test or not? If so, make sure your cluster is up!"
        )

    for index in INDICES:
        if es.indices.exists(index=index):
            es.indices.delete(index)

    yield es

    # TEARDOWN
    for index in INDICES:
        es.indices.delete(index)


def test_process_event(es):
    """
    Tests the core effect of the lambda.
    """
    process_event(constants.EVENT_MOCK_1, es)

    for index in INDICES:
        a = es.get(index, "abc")
        assert a.get("found")
        assert a.get("_id") == "abc"
        assert a["_source"].get("firstName") == "John"
        assert a["_source"].get("lastName") == "Doe"
        assert not a["_source"].get("isPublic")
        assert a["_source"].get("hashedEmail") == "0bc83cb571cd1c50ba6f3e8a78ef1346"
        assert a["_source"].get("email") == "test@yahoo.ca"

        b = es.get(index, "def")
        assert b.get("found")
        assert b.get("_id") == "def"
        assert b["_source"].get("firstName") == "Jane"
        assert b["_source"].get("lastName") == "River"
        assert b["_source"].get("isPublic")
        assert b["_source"].get("interests") == ["Volley Ball", "Natation"]
        if index == mappings.INDEX_MEMBER:
            assert b["_source"].get("virtualStudies") == [
                {"_id": "1", "name": "Virtual Study 1"},
                {"_id": "12", "name": "Virtual Study 2"},
            ]
        elif index == mappings.INDEX_MEMBERS:
            assert "virtualStudies" not in b["_source"]

        assert b["_source"].get("searchableInterests") == [
            {"name": "Volley Ball"},
            {"name": "Natation"},
        ]
