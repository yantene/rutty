FROM alpine:3.13.0

ARG LANGUAGE
ARG VERSION

RUN apk --no-cache add ${LANGUAGE}=${VERSION}-r0 sudo

COPY ./entry.sh /
RUN chmod 500 /entry.sh

ENTRYPOINT "/entry.sh"
