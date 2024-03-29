# :busts_in_silhouette: kf-lambda-member-update

This lambda receives events from the SQS queue that contains users from kf-persona. Upon reception, the lambda writes
these members to elastic search.

> **Note**: The lambda will try to create the index(es) if it does not exist.

## Installation

## :nut_and_bolt: Development

To run the unit test(s), from the root of the project directory do `scripts/test`

To obtain a terminal with all the dependencies do `scripts/console`.
Then, you can do

```
black path_to_your_file.py
# or
pylint path_to_your_file.py
```

to reformat a file with _black_ or perform linting with _pylint_ respectively.

These environment variables can be useful:

```
- es_host : Elastic Search cluster Host (by default, localhost)
- es_port : Elastic Search cluster Port (by default, 9200)
- es_scheme : Elastic Search client protocole scheme (by default, http)
```

### :running: Docker + Lambda

If you want to test the lambda with high fidelity (more [here](https://docs.aws.amazon.com/lambda/latest/dg/images-create.html)) you can do the following steps (adjust, if needed):

```
# Start a local Elasticsearch cluster. Notice the network it uses: "es-net".
docker-compose up

# Build the image
docker build -t <name-of-your-image> .

# Run the lambda the container
 docker run --rm -it --network="es-net" -p 9000:8080 -e es_host="elasticsearch" <name-of-your-image>

# Invoke the lambda. For instance,
curl --location --request POST 'http://localhost:9000/2015-03-31/functions/function/invocations' \
--header 'Content-Type: application/json' \
--data-raw '{
    "Records": [
        {
            "messageId": "059f36b4-87a3-44ab-83d2-661975830a7d",
            "body": "{\"_id\":\"abc\",\"firstName\":\"John\",\"lastName\":\"Doe\",\"hashedEmail\":\"0bc83cb571cd1c50ba6f3e8a78ef1346\",\"email\":\"test@yahoo.ca\"}"
        },
        {
            "messageId": "2e1424d4-f796-459a-8184-9c92662be6da",
            "body": "{\"_id\":\"def\",\"firstName\":\"Jane\",\"lastName\":\"River\",\"isPublic\":true,\"interests\":[\"Volley Ball\",\"Natation\"],\"virtualStudies\":[{\"_id\":\"1\",\"name\":\"Virtual Study 1\"},{\"_id\":\"12\",\"name\":\"Virtual Study 2\"}]}"
        }
    ]
}'
# Expected Output is: null

# Remove image
docker rmi <name-of-your-image>

# Shutdown your cluser
docker-compose down
```

> **:warning:**: Make sure that all the source file(s) needed to run the lambda is copied into the image.
