FROM python:3.8-slim-buster

WORKDIR /root
ENV VENV /opt/venv
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONPATH /root

RUN apt-get update && apt-get install -y build-essential curl


ENV VENV /opt/venv
# Virtual environment
RUN python3 -m venv ${VENV}
ENV PATH="${VENV}/bin:$PATH"

RUN curl -sL https://ctl.flyte.org/install > install.sh
RUN chmod +x install.sh
RUN ./install.sh v0.5.8
RUN mv ./bin/flytectl /bin

# Install Python dependencies
COPY ./requirements.txt /root
RUN pip install -r /root/requirements.txt

# Configure access to blob storage
ENV MLFLOW_S3_ENDPOINT_URL http://minio.flyte:9000
ENV AWS_ACCESS_KEY_ID minio
ENV AWS_SECRET_ACCESS_KEY miniostorage

# This tag is supplied by the build script and will be used to determine the version
# when registering tasks, workflows, and launch plans
ARG tag
ENV FLYTE_INTERNAL_IMAGE $tag
