ARG NODE_IMAGE=node:18.17
ARG PYTHON_IMAGE=python:3.11-slim

FROM $NODE_IMAGE AS frontend_base

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

WORKDIR /app

COPY fe/*.json /app/
RUN npm ci

COPY fe /app/
RUN npm run build
