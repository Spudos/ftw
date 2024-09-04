<<<<<<< HEAD
FROM ruby:3.1.2

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

# Set the working directory
WORKDIR /app

# Copy the app
COPY ../../. .

# Install the specific version of Bundler
RUN gem install bundler -v '2.3.19'

# Install dependencies
RUN bundle install

# Install Yarn dependencies
RUN yarn install

RUN RAILS_ENV=production bundle exec rails db:create && RAILS_ENV=production bundle exec rails db:schema:load

# Precompile assets
RUN RAILS_ENV=production bundle exec rails assets:precompile

# Run database migrations (if applicable)
RUN RAILS_ENV=production bundle exec rails db:migrate

# Start the app
CMD ["sh", "-c", "RAILS_ENV=production bundle exec rails s"]

# Expose the port
EXPOSE 3000

=======
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
>>>>>>> 32f04c17ea59cd8bbc27e811544da70778cdb8c8
