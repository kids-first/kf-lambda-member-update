#!/bin/bash

# Once in a terminal you can run, for instance: "black <my_python_file>" to reformat a file
docker run --rm -it -v "$PWD":/code --workdir /code python:3.9-slim-buster sh -c "pip install -r src/requirements.txt -r requirements.txt && sh"
