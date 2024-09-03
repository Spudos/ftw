FROM ruby:3.1.6

WORKDIR /app

EXPOSE 6379

CMD ["RAILS_ENV=production bundle exec sidekiq"]

