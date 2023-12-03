ARG NODE_IMAGE=node:18.17
ARG PYTHON_IMAGE=python:3.11-slim

FROM ${NODE_IMAGE} AS frontend_base

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

WORKDIR /app

COPY fe/*.json /app/
RUN npm ci

COPY fe /app/
RUN npm run build

FROM ${PYTHON_IMAGE} AS backend_base

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python3 - && \
    ln -s /opt/poetry/bin/poetry /usr/local/bin && \
    poetry config virtualenvs.create false

WORKDIR /app

COPY be/pyproject.toml be/poetry.lock /app/

RUN --mount=type=cache,target=/root/.cache/pypoetry \
    poetry install

COPY be /app/

RUN poetry install --no-dev

FROM ${PYTHON_IMAGE}

RUN apt-get update && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=frontend_base /app/dist /app/static
COPY --from=backend_base /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

COPY be /app/

ARG SHORT_SHA
RUN echo $SHORT_SHA > /commithash.txt

ENV PORT=8080

ENTRYPOINT ["python", "-m", "be", "server"]
