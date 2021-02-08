ARG LANGUAGE
ARG VERSION

FROM ${LANGUAGE}:openjdk-16-tools-deps-${VERSION}-alpine

COPY ./entry.sh /
RUN chmod 500 /entry.sh

ENTRYPOINT "/entry.sh"
