INDEX_MEMBER = "member"
INDEX_MEMBERS = "members"

COMMON_SETTINGS = {
    "analysis": {
        "analyzer": {
            "autocomplete": {
                "type": "custom",
                "tokenizer": "standard",
                "filter": ["lowercase", "custom_edge_ngram", "member_ascii_folding"],
            }
        },
        "filter": {
            "custom_edge_ngram": {
                "type": "edge_ngram",
                "min_gram": 1,
                "max_gram": 20,
                "side": "front",
            },
            "member_ascii_folding": {"type": "asciifolding", "preserve_original": True},
        },
    }
}

_MEMBER_MAPPING = {
    "settings": COMMON_SETTINGS,
    "mappings": {
        "properties": {
            "email": {"type": "keyword"},
            "hashedEmail": {"type": "keyword", "index": False},
            "institutionalEmail": {"type": "keyword"},
            "acceptedTerms": {"type": "boolean"},
            "isPublic": {"type": "boolean"},
            "isActive": {"type": "boolean"},
            "roles": {"type": "keyword"},
            "title": {"type": "keyword", "index": False},
            "firstName": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "lastName": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "jobTitle": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "institution": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "city": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "state": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "country": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "eraCommonsID": {"type": "keyword"},
            "bio": {"type": "text", "analyzer": "autocomplete"},
            "story": {"type": "text", "analyzer": "autocomplete"},
            "interests": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "virtualStudies": {
                "properties": {
                    "id": {"type": "keyword", "index": False},
                    "name": {
                        "type": "text",
                        "analyzer": "autocomplete",
                        "fields": {"raw": {"type": "keyword"}},
                    },
                },
                "type": "nested",
            },
            "searchableInterests": {
                "type": "nested",
                "properties": {
                    "name": {
                        "type": "text",
                        "analyzer": "autocomplete",
                        "fields": {"raw": {"type": "keyword"}},
                    }
                },
            },
        }
    },
}

_MEMBERS_MAPPING = {
    "settings": COMMON_SETTINGS,
    "mappings": {
        "properties": {
            "email": {"type": "keyword"},
            "hashedEmail": {"type": "keyword", "index": False},
            "institutionalEmail": {"type": "keyword"},
            "acceptedTerms": {"type": "boolean"},
            "isPublic": {"type": "boolean"},
            "isActive": {"type": "boolean"},
            "roles": {"type": "keyword"},
            "title": {"type": "keyword", "index": False},
            "firstName": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "lastName": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "jobTitle": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "institution": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "city": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "state": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "country": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "eraCommonsID": {"type": "keyword"},
            "bio": {"type": "text", "analyzer": "autocomplete"},
            "story": {"type": "text", "analyzer": "autocomplete"},
            "interests": {
                "type": "text",
                "analyzer": "autocomplete",
                "fields": {"raw": {"type": "keyword"}},
            },
            "searchableInterests": {
                "type": "nested",
                "properties": {
                    "name": {
                        "type": "text",
                        "analyzer": "autocomplete",
                        "fields": {"raw": {"type": "keyword"}},
                    }
                },
            },
        }
    },
}

INDEX_TO_MAPPING = {INDEX_MEMBER: _MEMBER_MAPPING, INDEX_MEMBERS: _MEMBERS_MAPPING}
