FROM ruby:3.1.1-alpine3.15

ENV DOCKER true

RUN apk --update add build-base tzdata

ENV APP_DIR /usr/app
RUN mkdir -p ${APP_DIR}
WORKDIR ${APP_DIR}

ADD Gemfile* .
ADD Rakefile .
ADD lib ./lib
ADD config ./config

RUN bundle config set --local without 'development test'
RUN bundle config set --local frozen 'true'
RUN bundle install

ENTRYPOINT [ "rake" ]