FROM ruby:2.5.5
LABEL maintainer="Refsheet.net Team <nerds@refsheet.net>"

WORKDIR /app

# Envirionment
ENV RACK_ENV production
ENV RAILS_ENV production
ENV PORT 3000

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


# Copy System Config
COPY ./config/imagemagick/policy.xml /etc/ImageMagick-6/policy.xml


# Bundle

WORKDIR /app

COPY Gemfile      /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install --without="development test" --deployment

## This will leak the token into our docker history, which is very bad
## but I didn't feel like spending all day trying to figure out if Kaniko
## even has a secure way to copy secrets in.
ARG SENTRY_RELEASE_TOKEN

COPY . /app

# Execute Order 66

EXPOSE $PORT

CMD echo "Starting with formation: $FORMATION" && foreman start --formation "$FORMATION" --env ""
