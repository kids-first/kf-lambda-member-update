FROM public.ecr.aws/lambda/python:3.8

COPY requirements.txt  .
RUN  pip3 install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

COPY mappings.py service.py "${LAMBDA_TASK_ROOT}"/

CMD [ "service.handler" ]