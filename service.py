"""
This code is meant for an AWS lambda.
Persona, a web service that manages users, sends user data
to this lambda in order to index it in elasticsearch.

Please note that we use two indices here: member and members.
The former (member) is used for legacy purposes. It has the concept of virtual studies.
The latter (members) is meant to be used in the service kf-api-arranger,
Members index and has no concept of virtual studies.
"""
from json import loads
from os import environ

from elasticsearch7 import Elasticsearch
from elasticsearch7.helpers import bulk

import mappings


def write_members_to_elasticsearch(es_client, index, docs):
    if not es_client.indices.exists(index=index):
        es_client.indices.create(index, body=mappings.INDEX_TO_MAPPING[index])
    if index == mappings.INDEX_MEMBERS:
        #Create or Update
        es_client.indices.put_alias(
            mappings.INDEX_MEMBERS,
            mappings.PUBLIC_MEMBERS_ALIAS,
            body={
                "actions": [
                    {
                        "add": {
                            "index": mappings.INDEX_MEMBERS,
                            "filter": {
                                "bool": {"filter": [{"term": {"isPublic": True}}]}
                            },
                        }
                    }
                ]
            },
        )
    bulk(es_client, docs)


def transform_event_to_docs(event, index, omit):
    """
    Takes an event and transform it to a suitable doc for the elastic search client.
    Arguments:
      event: service event – Amazon SNS notification
      index: the elastic search index name where that doc will be written to.
      omit: list of fields that we want to omit
    Returns:
      a generator with docs"""
    for record in event["Records"]:
        payload = loads(record["body"])
        yield dict(
            filter(
                lambda x: x[0] not in omit if len(omit) > 0 else True,
                {
                    "_index": index,
                    "_id": payload["_id"],
                    "firstName": payload.get("firstName"),
                    "lastName": payload.get("lastName"),
                    "email": payload.get("email"),
                    "hashedEmail": payload.get("hashedEmail"),
                    "institutionalEmail": payload.get("institutionalEmail"),
                    "acceptedTerms": payload.get("acceptedTerms"),
                    "isPublic": payload.get("isPublic", False),
                    "isActive": payload.get("isActive", True),
                    "roles": payload.get("roles"),
                    "title": payload.get("title"),
                    "jobTitle": payload.get("jobTitle"),
                    "institution": payload.get("institution"),
                    "city": payload.get("city"),
                    "state": payload.get("state"),
                    "country": payload.get("country"),
                    "eraCommonsID": payload.get("eraCommonsID"),
                    "bio": payload.get("bio"),
                    "story": payload.get("story"),
                    "interests": payload.get("interests"),
                    "virtualStudies": payload.get("virtualStudies"),
                    "searchableInterests": [
                        {"name": p} for p in (payload.get("interests") or [])
                    ],
                    "linkedin": payload.get("linkedin", ""),
                    "website": payload.get("website", ""),
                }.items(),
            )
        )


def build_es_client(host, port, scheme):
    return Elasticsearch([{"host": host, "port": port}], scheme=scheme)


def process_event(event, es_client):
    for index in [mappings.INDEX_MEMBER, mappings.INDEX_MEMBERS]:
        omit = ["virtualStudies"] if index == mappings.INDEX_MEMBERS else []
        docs = transform_event_to_docs(event, index, omit)
        write_members_to_elasticsearch(es_client, index, docs)


def handler(event, _):
    """
    Writes members to our elastic search cluster from an event sent by Persona service.
    An event contains information about members.
    These members are indexed in our elastic search cluster.
    Arguments:
      event: service event – Amazon SNS notification
      es_client: elastic search client
    Returns:
      Nothing is returned - it is a write operation.
    """
    es_client = build_es_client(
        environ.get("es_host", "localhost"),
        environ.get("es_port", "9200"),
        environ.get("es_scheme", "http"),
    )
    process_event(event, es_client)
