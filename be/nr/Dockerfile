FROM ubuntu:latest AS base

# builder stage
FROM base AS builder

# tell the system there is no one to answer it
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    python3-wheel \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# environment setup
ENV VENV=/usr/local/venv
RUN python3 -m venv $VENV
ENV PATH="${VENV}/bin:${PATH}"

# install requirements
COPY nr-requirements.txt .
RUN python3 -m pip install -U --no-cache-dir -r nr-requirements.txt

# runner stage
FROM base AS runner

ARG BUILD_DATE
ARG BUILD_VERSION
ARG NOD_USER

LABEL org.opencontainers.image.authors="joshuejs <github@joshuaejs.me>" \
  org.opencontainers.image.created=${BUILD_DATE} \
  org.opencontainers.image.version=${BUILD_VERSION} \
  org.opencontainers.image.title="nodpy" \
  org.opencontainers.image.description="nodpy - fastapi + nornir" \
  org.opencontainers.image.source="https://github.com/joshuaejs/nod/blob/main/Dockerfile" \
  org.opencontainers.image.url="https://github.com/joshuaejs/nod/"

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    openssh-client \
    python3 \
    python3-pip \
    python3-wheel \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV NOD_UID=1000
ENV NOD_GID="${NOD_UID}"

COPY --from=builder /usr/local/venv /srv/nod

RUN addgroup --gid "${NOD_GID}" "${NOD_USER}" \
  && useradd --system \
    --shell /bin/bash \
    --home-dir /srv/nod \
    --uid "${NOD_UID}" \
    --gid "${NOD_GID}" \
    "${NOD_USER}" \
  && mkdir ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/known_hosts && chown -R ${NOD_UID}:${NOD_GID} /srv/nod

COPY src/main.py /srv/nod/main.py
COPY src/nod /srv/nod/nod

USER "${NOD_USER}"
ENV PATH=/srv/nod/bin:$PATH

WORKDIR /srv/nod
EXPOSE 8080

CMD ["python3", "main.py"]
