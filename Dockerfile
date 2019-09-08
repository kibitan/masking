FROM ruby:2.6

WORKDIR /srv
RUN groupadd -r app && useradd --no-log-init --create-home -r -g app app
USER app

COPY --chown=app:app . .

RUN bundle install -j "$(nproc)"

CMD ["bundle", "exec", "exe/masking"]
