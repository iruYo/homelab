ARG BASE_TAG=3.13.5-alpine3.22
FROM python:${BASE_TAG} AS builder

ENV PATH=/opt/venv/bin:$PATH

RUN python3 -m venv /opt/venv

COPY requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -r /requirements.txt


FROM python:${BASE_TAG}

ARG USER=runner
ARG HOME_DIR=/home/${USER}
ARG ANSIBLE_DIR=${HOME_DIR}/ansible

RUN addgroup ${USER} && \
    adduser ${USER} -D -G ${USER} -h ${HOME_DIR} && \
    mkdir ${ANSIBLE_DIR} && \
    chown ${USER}:${USER} ${ANSIBLE_DIR}

RUN apk add --no-cache \
    openssh=10.0_p1-r7

COPY --from=builder /opt/venv /opt/venv

USER $USER
ENV PATH=/opt/venv/bin:$PATH
ENV ENV=${HOME_DIR}/.shinit

COPY .shinit ${ENV}
COPY entrypoint.sh /usr/bin/entrypoint.sh

WORKDIR ${ANSIBLE_DIR}

ENTRYPOINT [ "entrypoint.sh" ]