#!/bin/bash

puts "Starting the sidekiq container..."
gem install bundler -v '2.3.19'
bundle install
yarn install
RAILS_ENV=production bundle exec sidekiq
