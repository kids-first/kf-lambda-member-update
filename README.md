# kf-lambda-member-update

[![CircleCI](https://circleci.com/gh/kids-first/kf-lambda-member-update.svg?style=svg)](https://circleci.com/gh/kids-first/kf-lambda-member-update)

This lambda receive events from the SQS queue that contains users from kf-persona.

It takes into account two environment variables :
- es_host : Elastic Search cluster Host (by default, localhost)
- es_port : Elastic Search cluster Port (by default, 9200)

The lambda will try to create the index if it does not exists.

## Installation

```
pip install -r requirements.txt
```

If you want run the tests, you need an elasticsearch running in local. 
You should also install these dependencies :
```
pip install -r dev-requirements.txt
```
