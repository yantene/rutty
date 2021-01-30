FROM ruby:3.0.0-alpine

LABEL maintainer="contact@yantene.net"

ENV LANG "C.UTF-8"
ENV TZ "Asia/Tokyo"

WORKDIR /rutty

RUN \
  apk update && \
  apk upgrade && \
  apk add --no-cache linux-headers libxml2-dev make gcc libc-dev tzdata git

ENV RAILS_ENV production

COPY Gemfile* ./

RUN \
  apk add --virtual build-dependencies --no-cache build-base curl-dev && \
  bundle config set with ${RAILS_ENV} && \
  bundle install && \
  apk del build-dependencies

COPY . .

EXPOSE 3000

COPY ./docker/development/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]
