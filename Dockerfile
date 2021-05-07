FROM python:3.13-alpine

ENV VIRTUAL_ENV=/var/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN apk add --no-cache \
    bash \
    build-base \
    libffi-dev \
    openldap-dev \
    openssl-dev \
    postgresql-dev \
    py3-cryptography \
    python3-dev \
    xmlsec-dev

COPY . /app
WORKDIR /app

RUN python3 -m venv --system-site-packages ${VIRTUAL_ENV}

RUN pip install -r --no-cache-dir requirements.txt && \
    pip install -r --no-cache-dir requirements-ci.txt && \
    pip install .

ENV ALERTA_SVR_CONF_FILE /app/alertad.conf
ENV ALERTA_CONF_FILE /app/alerta.conf
ENV ALERTA_ENDPOINT=http://localhost:8080

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8080
ENV FLASK_SKIP_DOTENV=1
CMD ["alertad", "run", "--host", "0.0.0.0", "--port", "8080"]
