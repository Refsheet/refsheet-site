FROM ruby:2.5.1-alpine
LABEL maintainer="Refsheet.net Team <nerds@refsheet.net>"

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle

ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN apk update && apk add build-base nodejs postgresql-dev git yarn

RUN mkdir /app
WORKDIR /app

COPY Gemfile* ./
RUN bundle check || bundle install --binstubs="$BUNDLE_BIN"

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . ./

ENTRYPOINT ["bundle", "exec"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
