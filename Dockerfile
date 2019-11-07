FROM ruby:2.6-alpine AS app
RUN apk add --no-cache build-base git
WORKDIR /app
RUN addgroup -S app && adduser -S -G app app
USER app
COPY --chown=app . ./
RUN bundle install -j "$(nproc)"
ENTRYPOINT ["bundle", "exec", "exe/masking"]

FROM app AS with-mysql-client
USER root
RUN apk add --no-cache mysql-client
ARG user=app
USER $user
