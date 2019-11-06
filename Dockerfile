FROM ruby:2.6-alpine AS app
RUN apk add --no-cache build-base git
WORKDIR /app
RUN adduser -S app
USER app
COPY . .
RUN bundle install -j "$(nproc)"
ENTRYPOINT ["bundle", "exec", "exe/masking"]

FROM app AS docker-compose
USER root
RUN apk add --no-cache mysql-client
USER app
