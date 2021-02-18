FROM ruby:2.7.2-slim-buster as base

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    postgresql-client \
    sqlite3 && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

FROM base as builder

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends \
    build-essential \
    curl \
    libsqlite3-dev \
    libpq-dev \
    software-properties-common && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qy nodejs yarn && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

WORKDIR /app
COPY Gemfile* ./

FROM builder AS dev-build
WORKDIR /app
COPY . .
RUN bundle config set without 'production' && \
    bundle install --jobs 20 --retry 5 && \
    yarn install --check-files && \
    rails assets:precompile && \
    yarn cache clean

FROM base as dev
WORKDIR /app
COPY --from=dev-build /usr/local/bundle/ /usr/local/bundle/
COPY --from=dev-build /app .
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

FROM builder AS prod-build
WORKDIR /app
COPY . .
RUN bundle config set without 'test development' && \
    bundle install --jobs 20 --retry 5 && \
    yarn install --check-files && \
    RAILS_ENV=production rails assets:precompile && \
    yarn cache clean

FROM base as prod
WORKDIR /app
COPY --from=prod-build /app .
COPY --from=prod-build /usr/local/bundle/ /usr/local/bundle/
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
