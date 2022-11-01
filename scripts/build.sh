#!/bin/bash

REGION=$1
ACCOUNT_ID=$(aws sts get-caller-identity --output text | awk '{print $1}')

if [[ -n "${GIT_COMMIT}" ]]; then
    GIT_COMMIT="${GIT_COMMIT:0:7}"
else
    GIT_COMMIT="$(git rev-parse --short HEAD)"
fi

python3 -m venv venv && source ./venv/bin/activate && python -V
pip3 install -r requirements.txt

aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
docker build -t kf-strides-member-updates-lambda .
docker tag kf-strides-member-updates-lambda:latest ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/kf-strides-member-updates-lambda:${GIT_COMMIT}
docker push ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/kf-strides-member-updates-lambda:${GIT_COMMIT}