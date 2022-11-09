#!/bin/bash

docker run --rm -it -v "$PWD":/code --workdir /code python:3.9-slim-buster sh -c "pip install -r src/requirements.txt -r requirements.txt && pytest tests/unit; exit"
