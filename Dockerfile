FROM python:3.6-alpine3.8
COPY node-ping.py /app/
WORKDIR /app
ENTRYPOINT ["python3", "/app/node-ping.py"]