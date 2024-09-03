FROM ruby:3.1.6

WORKDIR /app

EXPOSE 6379

CMD ["sh", "-c", "RAILS_ENV=production bundle exec sidekiq"]