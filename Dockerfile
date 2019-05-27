FROM ruby:2.5.5
MAINTAINER Refsheet.net Team <nerds@refsheet.net>

RUN mkdir /app
WORKDIR /app


# Install System Deps

RUN apt-get update && \
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

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install -y nodejs


# Bundle

COPY Gemfile      /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install --without="development test"


# Yarn

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

COPY package.json /app/package.json
COPY yarn.lock    /app/yarn.lock

RUN yarn --pure-lockfile

ENV NODE_OPTIONS="--max-old-space-size=4096"


# Move App and Precompile

COPY . /app
RUN bundle exec rake assets:precompile RAILS_ENV=production


# Execute Order 66

EXPOSE 3000

ENV RACK_ENV production
ENV RAILS_ENV production
ENV NODE_ENV production
ENV PORT 3000

CMD foreman start --formation "$FORMATION" --env ""