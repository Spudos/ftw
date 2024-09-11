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

CMD ["sh", "-c", "./start_sidekiq.sh"]
