FROM ruby:2.3-alpine

RUN apk update && apk add build-base nodejs postgresql-dev git

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .

LABEL maintainer="Refsheet.net Team <nerds@refsheet.net>"

ENTRYPOINT bundle exec
EXPOSE 5000

CMD foreman start
