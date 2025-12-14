FROM ruby:2.7.8-slim-bookworm
LABEL maintainer="Refsheet.net Team <nerds@refsheet.net>"

WORKDIR /app

# Environment
ENV RACK_ENV production
ENV RAILS_ENV production
ENV PORT 3000
ENV BUNDLE_VERSION 2.3.26

# Install System Deps

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        libpq-dev \
        libxml2-dev \
        libxslt1-dev \
        libjpeg-dev \
        libpng-dev \
        libwebp-dev \
        libvips-dev \
        curl \
        git \
        pkg-config && \
    gem install bundler -v $BUNDLE_VERSION && \
    gem install foreman && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Copy System Config
COPY ./config/imagemagick/policy.xml /etc/ImageMagick-6/policy.xml


# Bundle

WORKDIR /app

COPY Gemfile      /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle config set --local without 'development test' && \
    bundle config set --local deployment 'true' && \
    bundle install

## This will leak the token into our docker history, which is very bad
## but I didn't feel like spending all day trying to figure out if Kaniko
## even has a secure way to copy secrets in.
ARG SENTRY_RELEASE_TOKEN

COPY . /app

# Execute Order 66

EXPOSE $PORT

CMD echo "Starting with formation: $FORMATION" && foreman start --formation "$FORMATION" --env ""
