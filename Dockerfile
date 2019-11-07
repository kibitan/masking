FROM ruby:2.6-alpine AS builder
RUN apk add --no-cache build-base git
WORKDIR /app
RUN addgroup -S app && adduser -S -G app app
USER app
COPY --chown=app . ./
RUN bundle install -j "$(nproc)"

FROM builder AS with-mysql-client
USER root
RUN apk add --no-cache mysql-client
USER app

FROM ruby:2.6-alpine
WORKDIR /app
# TODO: remove dependecy of `git` from masking.gemspec:L19
RUN apk add --no-cache git
RUN addgroup -S app && adduser -S -G app app
USER app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --chown=app . ./
ENTRYPOINT ["bundle", "exec", "exe/masking"]
