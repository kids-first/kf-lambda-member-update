from json import dumps

EVENT_MOCK_1 = {
    "Records": [
        {
            "messageId": "059f36b4-87a3-44ab-83d2-661975830a7d",
            "body": dumps(
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
            "body": dumps(
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
