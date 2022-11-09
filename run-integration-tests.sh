#!/bin/bash

# Make sure that a local elasticsearch is up and running (on es-net network).
docker run --rm -it --network=es-net -v "$PWD":/code --workdir /code python:3.9-slim-buster sh -c "pip install -r src/requirements.txt -r requirements.txt && pytest tests/integration; exit"
