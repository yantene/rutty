ARG IMPLEMENTATION
ARG VERSION

FROM ${IMPLEMENTATION}:${VERSION}-alpine3.10

RUN apk --no-cache add sudo

COPY ./entry.sh /
RUN chmod 500 /entry.sh

ENTRYPOINT "/entry.sh"
