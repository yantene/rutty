FROM ruby:3.0.0-alpine

ENV LANG "C.UTF-8"
ENV TZ "Asia/Tokyo"

ENV RUN_PKGS "linux-headers libxml2-dev make gcc libc-dev tzdata git"
ENV DEV_PKGS "build-base curl-dev"

RUN mkdir -p /opt/www/rutty

WORKDIR /opt/www/rutty

ARG RAILS_ENV
ENV RAILS_ENV ${RAILS_ENV:-production}

COPY Gemfile* ./

RUN apk update && apk upgrade

RUN apk add --no-cache ${RUN_PKGS}

RUN \
  apk add --virtual build-dependencies --no-cache ${DEV_PKGS} && \
  bundle config set --local with ${RAILS_ENV} &&\
  bundle install && \
  apk del build-dependencies

COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]
