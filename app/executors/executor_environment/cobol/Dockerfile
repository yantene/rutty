FROM alpine:3.13.0

ARG IMPLEMENTATION
ARG VERSION
ARG MINOR_VERSION

ENV RUN_PKGS "gmp-dev db-dev build-base"
ENV DEV_PKGS "curl"
ENV SOURCE_URL "https://sourceforge.net/projects/${IMPLEMENTATION}/files/${IMPLEMENTATION}/${MINOR_VERSION}/${IMPLEMENTATION}-${VERSION}.tar.xz/download"

RUN apk --no-cache add ${RUN_PKGS}

RUN \
  apk add --virtual build-dependencies --no-cache ${DEV_PKGS} && \
  curl -L ${SOURCE_URL} | tar Jxf - && \
  cd /${IMPLEMENTATION}-${VERSION} && \
  ./configure && \
  make && \
  make install && \
  rm -rf /${IMPLEMENTATION}-${VERSION} && \
  apk del build-dependencies

RUN apk --no-cache add sudo

COPY ./entry.sh /
RUN chmod 500 /entry.sh

ENTRYPOINT "/entry.sh"
