FROM ruby:2.7.2-slim-buster as base

WORKDIR /app

COPY . /app

RUN apt-get update -qq && apt-get install -y --no-install-recommends libsqlite3-dev sqlite3 \
    libpq-dev postgresql-client curl build-essential software-properties-common && \
    curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install yarn && \
    bundle install --jobs 20 --retry 5 && \
    apt-get remove -y curl libsqlite3-dev libpq-dev && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/ && \
    bundle config set without 'development test' && \
    bundle install --jobs 20 --retry 5 && \
    yarn install --check-files && \
    RAILS_ENV=production rails assets:precompile

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

FROM base AS app

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
