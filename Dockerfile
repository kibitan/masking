ARG RUBY_VERSION=3.2

FROM ruby:${RUBY_VERSION}-alpine AS builder
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

FROM ruby:${RUBY_VERSION}-alpine
# TODO: remove dependecy of `git` from masking.gemspec:L19
RUN apk add --no-cache git
RUN addgroup -S app && adduser -S -G app app
ENV PATH $PATH:/app/exe
WORKDIR /app
RUN chown app /app
USER app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --chown=app . ./
# workaround: at some reason, ruby-prof is not recognized in Ruby 2.6 image https://app.circleci.com/pipelines/github/kibitan/masking/197/workflows/8cbdb843-a42f-413a-ab2f-9c5f74397d43/jobs/512
RUN bundle
ENTRYPOINT ["bundle", "exec", "exe/masking"]
