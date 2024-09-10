#!/bin/bash

RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails s
