ARG LANGUAGE
ARG VERSION

FROM ${LANGUAGE}:${VERSION}-cli-alpine

RUN apk --no-cache add sudo

RUN echo "display_errors = stderr" > /usr/local/etc/php/php.ini

COPY ./entry.sh /
RUN chmod 500 /entry.sh

ENTRYPOINT "/entry.sh"
