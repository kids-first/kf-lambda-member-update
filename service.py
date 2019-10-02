import json
import os

from elasticsearch6 import Elasticsearch
from elasticsearch6.helpers import bulk

from mapping import MEMBER_INDEX


def handler(event, context):
    """
    Entry point to the lambda function
    """
    es_host = os.environ.get('es_host', 'localhost')
    es_port = os.environ.get('es_port', '9200')
    es = Elasticsearch([{'host': es_host, 'port': es_port}])
    es.indices.create('member', body=MEMBER_INDEX, ignore=400)
    records = transform(event)
    bulk(es, records)


def transform(event):
    for record in event['Records']:
        payload = json.loads(record["body"])
        yield {
            '_index': 'member',
            '_type': 'member',
            '_id': payload['_id'],
            'firstName': payload.get('firstName'),
            'lastName': payload.get('lastName'),
            'email': payload.get('email'),
            'institutionalEmail': payload.get('institutionalEmail'),
            'acceptedTerms': payload.get('acceptedTerms'),
            'isPublic': payload.get('isPublic') or False,
            'roles': payload.get('roles'),
            'title': payload.get('title'),
            'jobTitle': payload.get('jobTitle'),
            'institution': payload.get('institution'),
            'city': payload.get('city'),
            'state': payload.get('state'),
            'country': payload.get('country'),
            'eraCommonsID': payload.get('eraCommonsID'),
            'bio': payload.get('bio'),
            'story': payload.get('story'),
            'interests': payload.get('interests'),
            'virtualStudies': payload.get('virtualStudies')
        }
