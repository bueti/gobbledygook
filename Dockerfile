# syntax=docker/dockerfile:1.2
FROM ruby:2.7.2-alpine as base

RUN apk add --no-cache postgresql-dev tzdata bash
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

FROM base as builder

RUN apk add --no-cache \
  build-base \
  gcc \
  nodejs \
  yarn

FROM builder AS dev-builder
WORKDIR /app
COPY . .
RUN bundle config set without 'production' && \
    bundle install --jobs 20 --retry 5 && \
    yarn install --check-files && \
    rails assets:precompile && \
    yarn cache clean

FROM base as app-dev
WORKDIR /app
COPY --from=dev-builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=dev-builder /usr/bin/node* /usr/bin/
COPY --from=dev-builder /usr/bin/yarn* /usr/bin/
COPY --from=dev-builder /app .

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

FROM builder AS prod-builder
WORKDIR /app
COPY . .
RUN bundle config set without 'test development' && \
    bundle install --jobs 20 --retry 5 && \
    yarn install --check-files && \
    RAILS_ENV=production SECRET_KEY_BASE=1 rails assets:precompile && \
    yarn cache clean

FROM base as app-prod
WORKDIR /app
COPY --from=prod-builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=prod-builder /usr/bin/node* /usr/bin/
COPY --from=prod-builder /usr/bin/yarn* /usr/bin/
COPY --from=prod-builder /app .

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-e", "production"]
