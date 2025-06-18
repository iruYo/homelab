ARG BASE_TAG=3.13.5-alpine3.22
FROM python:${BASE_TAG} AS builder

ENV PATH=/opt/venv/bin:$PATH

RUN python3 -m venv /opt/venv

# hadolint ignore=DL3045
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt


FROM python:${BASE_TAG}

ARG USER=runner

RUN addgroup ${USER} && \
    adduser ${USER} -D -G ${USER} -h /home/${USER}

RUN apk add --no-cache \
    git=2.49.0-r0

COPY --from=builder /opt/venv /opt/venv

USER $USER
ENV PATH=/opt/venv/bin:$PATH

WORKDIR /home/${USER}
