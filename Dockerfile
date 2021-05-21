FROM ruby:2.5.5
LABEL maintainer="Refsheet.net Team <nerds@refsheet.net>"

WORKDIR /app

# Envirionment
ENV RACK_ENV production
ENV RAILS_ENV production
ENV NODE_ENV production
ENV PORT 3000

ENV NODE_VERSION 10.17.0
ENV VIPS_VERSION 8.9.0
ENV BUNDLE_VERSION 2.0.1

# Install System Deps

RUN apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get install -y \
        build-essential \
        libpq-dev \
        libxml2-dev \
        libxslt1-dev \
        libjpeg-dev \
        libpng-dev \
        libwebp-dev \
        curl \
        git && \
    gem install bundler -v $BUNDLE_VERSION && \
    gem install foreman


# Install Node

ENV NVM_DIR /usr/local/nvm
WORKDIR $NVM_DIR

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
ENV NODE_OPTIONS "--max-old-space-size=2048"


# Install Vips

WORKDIR /libvips

RUN curl -L "https://github.com/libvips/libvips/releases/download/v$VIPS_VERSION/vips-$VIPS_VERSION.tar.gz" \
    | tar -xzC /libvips && \
    cd vips-$VIPS_VERSION && \
    ./configure && \
    make && \
    make install && \
    ldconfig && \
    cd /libvips && \
    rm -rf vips-*


# Install Yarn

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get install -y yarn


# Copy System Config
COPY ./config/imagemagick/policy.xml /etc/ImageMagick-6/policy.xml


# Bundle

WORKDIR /app

COPY Gemfile      /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install --without="development test" --deployment

COPY package.json /app/package.json
COPY yarn.lock    /app/yarn.lock
COPY .yalc        /app/.yalc

RUN yarn --pure-lockfile


# Move App and Precompile

## This will leak the token into our docker history, which is very bad
## but I didn't feel like spending all day trying to figure out if Kaniko
## even has a secure way to copy secrets in.
ARG SENTRY_RELEASE_TOKEN

COPY . /app

RUN mkdir -p /cache && \
    touch /cache/warm && \
    mkdir -p /app/tmp/cache && \
    cp -R /cache/* /app/tmp/cache && \
    SECRET_KEY_BASE=nothing \
    RDS_DB_ADAPTER=nulldb \
    VERSION=$(cat /app/VERSION) \
    SENTRY_RELEASE_TOKEN="$SENTRY_RELEASE_TOKEN" \
    bundle exec rake assets:precompile RAILS_ENV=production && \
    mkdir -p /artifacts && \
    cp -R /app/public/* /artifacts && \
    cp -R /app/tmp/cache/* /cache && \
    rm -rf /app/tmp/*


# Execute Order 66

EXPOSE $PORT

CMD echo "Starting with formation: $FORMATION" && foreman start --formation "$FORMATION" --env ""
