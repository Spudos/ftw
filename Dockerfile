FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

COPY . /app

ENV REDIS_URL=redis://redis:6379/0

CMD ["bundle", "exec", "sidekiq"]