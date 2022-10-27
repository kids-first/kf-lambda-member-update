import json
from service import transform_event_to_docs

EVENT_MOCK_1 = {
    "Records": [
        {
            "messageId": "059f36b4-87a3-44ab-83d2-661975830a7d",
            "body": json.dumps(
                {
                    "_id": "abc",
                    "firstName": "John",
                    "lastName": "Doe",
                    "hashedEmail": "0bc83cb571cd1c50ba6f3e8a78ef1346",
                    "email": "test@yahoo.ca",
                }
            ),
        },
        {
            "messageId": "2e1424d4-f796-459a-8184-9c92662be6da",
            "body": json.dumps(
                {
                    "_id": "def",
                    "firstName": "Jane",
                    "lastName": "River",
                    "isPublic": True,
                    "interests": ["Volley Ball", "Natation"],
                    "virtualStudies": [
                        {"_id": "1", "name": "Virtual Study 1"},
                        {"_id": "12", "name": "Virtual Study 2"},
                    ],
                }
            ),
        },
    ]
}


def test_handler():
    """
    Test the service handler
    """

    # es = Elasticsearch(['elasticsearch'], port=9200)
    print("testppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp")
    es = Elasticsearch(["elasticsearch"], scheme="http", port=9200)
    print("hello")
    print(es.info())
    return
    # es = Elasticsearch()
    es.indices.delete("member", ignore_unavailable=True)
    service.handler(EVENT_MOCK_1, {})

    a = es.get("member", "abc")
    assert a.get("found")
    assert a.get("_id") == "abc"
    assert a["_source"].get("firstName") == "John"
    assert a["_source"].get("lastName") == "Doe"
    assert not a["_source"].get("isPublic")
    assert a["_source"].get("hashedEmail") == "0bc83cb571cd1c50ba6f3e8a78ef1346"
    assert a["_source"].get("email") == "test@yahoo.ca"

    b = es.get("member", "def")
    assert b.get("found")
    assert b.get("_id") == "def"
    assert b["_source"].get("firstName") == "Jane"
    assert b["_source"].get("lastName") == "River"
    assert b["_source"].get("isPublic")
    assert b["_source"].get("interests") == ["Volley Ball", "Natation"]
    assert b["_source"].get("virtualStudies") == [
        {"_id": "1", "name": "Virtual Study 1"},
        {"_id": "12", "name": "Virtual Study 2"},
    ]
    assert b["_source"].get("searchableInterests") == [
        {"name": "Volley Ball"},
        {"name": "Natation"},
    ]
