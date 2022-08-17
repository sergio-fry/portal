FROM ruby:3.1.1 as dev
ENV NODE_MAJOR 16
ENV YARN_VERSION 1.22.17-1

RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee /usr/share/keyrings/nodesource.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x bullseye main" | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x bullseye main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    curl -s https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt update && \
    apt install -y --no-install-recommends \
        nodejs \
        yarn=$YARN_VERSION


COPY Aptfile /tmp/Aptfile
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    libpq-dev \
    postgresql-client \
    $(grep -Ev '^\s*#' /tmp/Aptfile | xargs) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install -j $(nproc) && \
    bundle config set --local frozen 'true'


COPY . /app/
RUN bundle exec rake assets:precompile


FROM dev AS runtime-gems
RUN bundle install --frozen -j $(nproc) --without test development
RUN bundle clean --force


FROM ruby:3.1.1-slim
WORKDIR /app

COPY Aptfile /tmp/Aptfile
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(grep -Ev '^\s*#' /tmp/Aptfile | xargs) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

COPY . /app/

COPY --from=runtime-gems /usr/local/bundle /usr/local/bundle
COPY --from=dev /usr/share/mime/packages/freedesktop.org.xml /usr/share/mime/packages/
RUN rm -rf /app/public/assets
COPY --from=dev /app/public/assets /app/public/assets

EXPOSE 3000

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["web"]
