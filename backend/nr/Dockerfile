FROM python:3-slim

# tell the system there is no one to answer it
ENV DEBIAN_FRONTEND=noninteractive

ARG BUILD_DATE
ARG BUILD_VERSION
ARG ADMIN_USER

LABEL org.opencontainers.image.authors="joshuejs <github@joshuaejs.me>" \
  org.opencontainers.image.created=${BUILD_DATE} \
  org.opencontainers.image.version=${BUILD_VERSION} \
  org.opencontainers.image.title="pynod" \
  org.opencontainers.image.description="a network operations dashboard (NOD) in python" \
  org.opencontainers.image.source="https://github.com/joshuaejs/nod/blob/main/Dockerfile" \
  org.opencontainers.image.url="https://github.com/joshuaejs/nod/"

ENV DEFAULT_UID=1000
ENV DEFAULT_GID="${DEFAULT_UID}"
ARG NOD_UID
ARG NOD_GID
RUN test -n "${NOD_UID}" && test -n "${NOD_GID}"
ENV NOD_UID="${NOD_UID}"
ENV NOD_GID="${NOD_GID}"

RUN if [ "$NOD_UID" = 0 ]; then NOD_UID=$DEFAULT_UID; fi \
  && if [ "$NOD_GID" = 0 ]; then NOD_GID=$DEFAULT_GID; fi \
  && addgroup --gid "${NOD_GID:-$DEFAULT_UID}" "${ADMIN_USER}" \
  && useradd --system \
    --shell /bin/bash \
    --create-home --home-dir /srv/nod \
    --uid "${NOD_UID:-$DEFAULT_UID}" \
    --gid "${NOD_GID:-$DEFAULT_GID}" \
    "${ADMIN_USER}" \
  && mkdir ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/known_hosts \
  && apt-get update -qq && apt-get install -y --no-install-recommends gcc

COPY ./requirements.txt /srv/nod
COPY ./nr_data /srv/nod/nr_data/
COPY nod/ /srv/nod/nod/

USER "${ADMIN_USER}"
ENV PATH=/srv/nod/.local/bin:/srv/nod/bin:$PATH

WORKDIR /srv/nod
RUN pip install -r requirements.txt

# CMD ["python3", "main.py"]
CMD ["bash"]
