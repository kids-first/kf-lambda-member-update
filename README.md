# kf-lambda-member-update

This lambda receive events from the SQS queue that contains users from persona.

It takes into account two environment variables :
- es_host : Elastic Search cluster Host (by default, localhost)
- es_port : Elastic Search cluster Port (by default, 9200)

## Installation

```
pip install -r requirements.txt
```

If you want run the tests. you should also install these dependencies :
```
pip install -r dev-requirements.txt
```
