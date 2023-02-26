ARG ruby_version=3.2

FROM ruby:$ruby_version-alpine AS builder
RUN apk add --no-cache build-base git
RUN addgroup -S app && adduser -S -G app app
USER app
WORKDIR /app
COPY --chown=app . ./
RUN gem install bundler:2.4.7 && bundle install -j "$(nproc)"

FROM builder AS with-mysql-client
USER root
RUN apk add --no-cache mysql-client
USER app

FROM ruby:$ruby_version-alpine
# TODO: remove dependecy of `git` from masking.gemspec:L19
RUN apk add --no-cache git
RUN addgroup -S app && adduser -S -G app app
ENV PATH $PATH:/app/exe
WORKDIR /app
RUN chown app /app
USER app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --chown=app . ./
ENTRYPOINT ["bundle", "exec", "exe/masking"]
