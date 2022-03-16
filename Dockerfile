FROM ruby:3.1.1-alpine3.15 AS base

RUN apk --update add tzdata

FROM base as dependencies

RUN apk --update add build-base tzdata

COPY --chown=${APP_USER} Gemfile* ./
RUN bundle config set --local without 'development test'
RUN bundle config set --local frozen 'true'
RUN bundle install --jobs=3 --retry=3

# NOTE: use of multi-stage to excluded build-base
# decreases image isze from 127.44 Mb to 58.94 Mb, 46% reduction!!
FROM base

ENV APP_USER app
RUN adduser -D ${APP_USER}
USER ${APP_USER}
WORKDIR /home/${APP_USER}

COPY --from=dependencies /usr/local/bundle /usr/local/bundle/
WORKDIR /home/${APP_USER}

COPY --chown=${APP_USER} Rakefile ./
COPY --chown=${APP_USER} lib ./lib
COPY --chown=${APP_USER} config ./config

CMD [ "rake" ]
