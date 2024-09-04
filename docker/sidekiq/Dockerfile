<<<<<<< HEAD
FROM ruby:3.1.6

WORKDIR /app

EXPOSE 6379

CMD ["sh", "-c", "RAILS_ENV=production bundle exec sidekiq"]
=======
FROM ruby:3.1

RUN apt-get install git

WORKDIR /usr/src/app

COPY ../../. .

# RUN git clone git@github.com:Spudos/ftw.git && cd ftw && bundle install

EXPOSE 6379

# COPY Gemfile Gemfile.lock ./
# RUN bundle install

# COPY . .

CMD ["RAILS_ENV=production bundle exec sidekiq"]
>>>>>>> 32f04c17ea59cd8bbc27e811544da70778cdb8c8
