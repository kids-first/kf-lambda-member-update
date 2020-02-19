MEMBER_INDEX = {
    "settings": {
        "analysis": {
            "analyzer": {
                "autocomplete": {
                    "type": "custom",
                    "tokenizer": "standard",
                    "filter": [
                        "lowercase",
                        "edge_ngram",
                        "member_ascii_folding"
                    ]
                }
            },
            "filter": {
                "edge_ngram": {
                    "type": "edgeNGram",
                    "min_gram": 1,
                    "max_gram": 20,
                    "side": "front"
                },
                "member_ascii_folding": {
                    "type": "asciifolding",
                    "preserve_original": True
                }
            }
        }
    },
    "mappings": {
        "member": {
            "properties": {
                "email": {
                    "type": "keyword"
                },
                "hashedEmail": {
                    "type": "keyword",
                    "index": False
                },
                "institutionalEmail": {
                    "type": "keyword"
                },
                "acceptedTerms": {
                    "type": "boolean"
                },
                "isPublic": {
                    "type": "boolean"
                },
                "isActive": {
                    "type": "boolean"
                },
                "roles": {
                    "type": "keyword"
                },
                "title": {
                    "type": "keyword",
                    "index": False
                },
                "firstName": {
                    "type": "text",
                    "analyzer": "autocomplete",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "lastName": {
                    "type": "text",
                    "analyzer": "autocomplete",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "jobTitle": {
                    "type": "text",
                    "analyzer": "autocomplete",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "institution": {
                    "type": "text",
                    "analyzer": "autocomplete",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "city": {
                    "type": "text",
                    "analyzer": "autocomplete",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "state": {
                    "type": "text",
                    "analyzer": "autocomplete",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "country": {
                    "type": "text",
                    "analyzer": "autocomplete",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "eraCommonsID": {
                    "type": "keyword"
                },
                "bio": {
                    "type": "text",
                    "analyzer": "autocomplete"
                },
                "story": {
                    "type": "text",
                    "analyzer": "autocomplete"
                },
                "interests": {
                    "type": "text",
                    "analyzer": "autocomplete",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "virtualStudies": {
                    "properties": {
                        "id": {
                            "type": "keyword",
                            "index": False
                        },
                        "name": {
                            "type": "text",
                            "analyzer": "autocomplete",
                            "fields": {
                                "raw": {
                                    "type": "keyword"
                                }
                            }
                        }
                    },
                    "type": "nested"
                },
                "searchableInterests": {
                    "type": "nested",
                    "properties": {
                        "name": {
                            "type": "text",
                            "analyzer": "autocomplete",
                            "fields": {
                                "raw": {
                                    "type": "keyword"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}