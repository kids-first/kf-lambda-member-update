FROM public.ecr.aws/lambda/python:3.9

WORKDIR /code

COPY src/ ${LAMBDA_TASK_ROOT}
RUN pip3 install -r ${LAMBDA_TASK_ROOT}/requirements.txt --target "${LAMBDA_TASK_ROOT}"

CMD ["app.handler"]
