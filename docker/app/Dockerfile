FROM ruby:3.1.2

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn \
    && apt-get install -y postgresql-client

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

# Precompile assets
RUN RAILS_ENV=production bundle exec rails assets:precompile

# Start the app
CMD ["sh", "-c", "start.sh"]

# Expose the port
EXPOSE 3000

