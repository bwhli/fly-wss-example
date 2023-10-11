FROM python:3.11-bookworm as poetry
ENV POETRY_VERSION=1.5.1
RUN curl -sSL https://install.python-poetry.org | python
WORKDIR /app

FROM python:3.11-bookworm as venv
COPY --from=poetry /root/.local /root/.local
ENV PATH /root/.local/bin:$PATH
WORKDIR /app
COPY pyproject.toml poetry.lock ./
RUN python -m venv --copies /app/venv && \
    . /app/venv/bin/activate && \
    poetry install --no-root --no-dev

FROM python:3.11-slim-bookworm as prod
WORKDIR /app
COPY --from=venv /app/venv /app/venv/
ENV PATH /app/venv/bin:$PATH
COPY ./fly_wss_example /app/fly_wss_example
CMD ["hypercorn", "fly_wss_example.main:app", "--bind", "0.0.0.0:8080"]
