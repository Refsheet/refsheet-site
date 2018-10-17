FROM starefossen/ruby-node:2-6-slim
LABEL maintainer="Refsheet.net Team <nerds@refsheet.net>"

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle \
    RAILS_ENV=production \
    NODE_ENV=production

ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN apt-get update \
 && apt-get install -y \
    libpq-dev git build-essential \
    postgresql-client libssl1.0-dev

RUN mkdir -p /app
WORKDIR /app

# Install Gems
COPY Gemfile* ./
RUN bundle check \
 || bundle install \
      --binstubs="$BUNDLE_BIN" \
      --deployment \
      --without="test development"

# Install Node Modules
COPY package.json yarn.lock ./
RUN bundle exec yarn install --frozen-lockfile

# Copy Application Files
COPY . ./

# Precompile Assets
RUN bundle exec rake assets:precompile

ENTRYPOINT ["bundle", "exec"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
