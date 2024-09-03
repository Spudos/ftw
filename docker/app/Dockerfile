FROM ruby:3.1

RUN apt-get install git

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

# use COPY or git clone - one or another, not both
COPY ../../. .

# RUN git clone git@github.com:Spudos/ftw.git && cd ftw && bundle install

RUN RAILS_ENV=production bundle exec rails db:create && RAILS_ENV=production bundle exec rails db:schema:load

RUN yarn && RAILS_ENV=production bundle exec rails assets:precompile

EXPOSE 3000

# COPY Gemfile Gemfile.lock ./
# RUN bundle install

CMD ["./start.sh"]
