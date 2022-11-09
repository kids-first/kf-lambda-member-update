import tests.constants as constants
from src import app


def test_transform_event_to_docs():
    docs = app.transform_event_to_docs(constants.EVENT_MOCK_1, "member", [])
    l_docs = list(docs)
    assert len(l_docs) == 2
    doc2 = l_docs[1]
    assert any(k == "virtualStudies" for k in doc2.keys())

    docs = app.transform_event_to_docs(
        constants.EVENT_MOCK_1, "members", ["virtualStudies"]
    )
    l_docs = list(docs)
    assert len(l_docs) == 2
    doc2 = l_docs[1]
    assert all(k != "virtualStudies" for k in doc2.keys())
