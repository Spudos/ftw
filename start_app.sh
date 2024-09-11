#!/bin/bash

gem install bundler -v '2.3.19'
bundle install
yarn install
RAILS_ENV=production bundle exec rails assets:precompile
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails s
