FROM ruby:2.6-alpine

WORKDIR /app
RUN apk add --no-cache build-base git
RUN adduser -S app
USER app

COPY . .

RUN bundle install -j "$(nproc)"

CMD ["bundle", "exec", "exe/masking"]
