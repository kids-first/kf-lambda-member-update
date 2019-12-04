import json

from elasticsearch6 import Elasticsearch

import service


def test_handler():
    """
    Test the service handler
    """
    es = Elasticsearch()
    es.indices.delete('member', ignore_unavailable=True)
    service.handler({
        "Records": [
            {
                "messageId": "059f36b4-87a3-44ab-83d2-661975830a7d",
                "body": json.dumps({"_id": "abc", "firstName": "John", "lastName": "Doe"})
            },
            {
                "messageId": "2e1424d4-f796-459a-8184-9c92662be6da",
                "body": json.dumps(
                    {"_id": "def", "firstName": "Jane", "lastName": "River", "isPublic": True,
                     "interests": ["Volley Ball", "Natation"],
                     "virtualStudies": [{"_id": "1", "name": "Virtual Study 1"},
                                        {"_id": "12", "name": "Virtual Study 2"}]}),
            }
        ]
    }, {})

    a = es.get('member', 'member', 'abc')
    assert a.get('found')
    assert a.get('_id') == 'abc'
    assert a['_source'].get('firstName') == 'John'
    assert a['_source'].get('lastName') == 'Doe'
    assert not a['_source'].get('isPublic')

    b = es.get('member', 'member', 'def')
    assert b.get('found')
    assert b.get('_id') == 'def'
    assert b['_source'].get('firstName') == 'Jane'
    assert b['_source'].get('lastName') == 'River'
    assert b['_source'].get('isPublic')
    assert b['_source'].get('interests') == ["Volley Ball", "Natation"]
    assert b['_source'].get('virtualStudies') == [{"_id": "1", "name": "Virtual Study 1"},
                                                  {"_id": "12", "name": "Virtual Study 2"}]
    assert b['_source'].get('searchableInterests') == [{"name": "Volley Ball"}, {"name": "Natation"}]
