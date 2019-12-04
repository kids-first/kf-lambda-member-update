MEMBER_INDEX = {
    "mappings": {
        "member": {
            "properties": {
                "email": {
                    "type": "keyword"
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
                "roles": {
                    "type": "keyword"
                },
                "title": {
                    "type": "keyword",
                    "index": False
                },
                "firstName": {
                    "type": "text",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "lastName": {
                    "type": "text",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "jobTitle": {
                    "type": "text",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "institution": {
                    "type": "text",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "city": {
                    "type": "text",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "state": {
                    "type": "text",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "country": {
                    "type": "text",
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
                    "type": "text"
                },
                "story": {
                    "type": "text"
                },
                "interests": {
                    "type": "text",
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