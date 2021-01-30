ARG LANGUAGE
ARG VERSION

FROM ${LANGUAGE}:${VERSION}-alpine

RUN apk --no-cache add sudo

COPY ./entry.sh /
RUN chmod 500 /entry.sh

ENTRYPOINT "/entry.sh"
