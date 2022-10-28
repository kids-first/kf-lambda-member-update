# :busts_in_silhouette: kf-lambda-member-update


This lambda receives events from the SQS queue that contains users from kf-persona. Upon reception, the lambda writes
these members to elastic search.

> **Note**: The lambda will try to create the index(es) if it does not exist.
## Installation


## :nut_and_bolt: Installation && Development
The `run.sh` script lets you different options to run various part of the program:
```
chmod +x ./run.sh
./run.sh
```
Please note that if you want to run the integration test(s) you need an elastic search
cluster running locally. In that case, before running any test do:
```
docker-compose up
```
Afterwards, you can run the integration test.
> **Note**: To shut down the cluster: docker-compose down

If you want to format a file with _black_ tool, once in the docker's terminal
```
black path_to_your_file.py
```
Similar for pylint
```
pylint path_to_your_file.py
```

These environment variables can be useful:
```
- es_host : Elastic Search cluster Host (by default, localhost)
- es_port : Elastic Search cluster Port (by default, 9200)
- es_scheme : Elastic Search client protocole scheme (by default, http)
```

