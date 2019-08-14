FROM ruby:2.5.5
MAINTAINER Refsheet.net Team <nerds@refsheet.net>

RUN mkdir /app
WORKDIR /app


# Runtime ENV

ENV RACK_ENV production
ENV RAILS_ENV production
ENV NODE_ENV production
ENV PORT 3000
ENV NODE_OPTIONS="--max-old-space-size=4096"


# Install System Deps

RUN apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get install -y \
        build-essential \
        libpq-dev \
        libxml2-dev \
        libxslt1-dev \
        libjpeg-dev \
        libpng-dev \
        curl \
        git && \
    gem install bundler -v 2.0.1 && \
    gem install foreman


# Install Node

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.11.3

WORKDIR $NVM_DIR

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn


# Bundle

WORKDIR /app

COPY Gemfile      /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install --without="development test" --deployment


# Yarn

COPY package.json /app/package.json
COPY yarn.lock    /app/yarn.lock

RUN yarn --pure-lockfile


# Copy System Config

COPY ./config/imagemagick/policy.xml /etc/ImageMagick-6/policy.xml

# Move App

COPY . /app

RUN bundle exec rake assets:precompile

# Execute Order 66

EXPOSE 3000
CMD foreman start --formation "$FORMATION" --env ""