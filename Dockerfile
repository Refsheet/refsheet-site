FROM ruby:2.5.5
MAINTAINER Refsheet.net Team <nerds@refsheet.net>

RUN mkdir /app
WORKDIR /app


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


# Bundle

WORKDIR /app

COPY Gemfile      /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install --without="development test" --deployment


# Yarn

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y yarn

COPY package.json /app/package.json
COPY yarn.lock    /app/yarn.lock

RUN yarn --pure-lockfile

ENV NODE_OPTIONS="--max-old-space-size=2048"


# Move App and Precompile

COPY . /app

RUN mkdir -p /cache && mkdir -p /app/tmp/cache && cp -R /cache/* /app/tmp/cache

RUN SECRET_KEY_BASE=nothing \
    RDS_DB_ADAPTER=nulldb \
    bundle exec rake assets:precompile RAILS_ENV=production

RUN mkdir -p /artifacts && cp -R /app/public/* /artifacts && cp -R /app/tmp/cache/* /cache

# Copy System Config
COPY ./config/imagemagick/policy.xml /etc/ImageMagick-6/policy.xml

# Set Version
ARG VERSION
RUN echo "$VERSION" > ./VERSION

# Execute Order 66

EXPOSE 3000

ENV RACK_ENV production
ENV RAILS_ENV production
ENV NODE_ENV production
ENV PORT 3000

CMD foreman start --formation "$FORMATION" --env ""