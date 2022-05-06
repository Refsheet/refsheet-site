source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

ruby '2.5.5'

# == BACK END

gem 'rails', '~> 6.0.0'
gem 'rake', '~> 12.3.1'
gem 'rack-cors'
gem 'pg', '~> 0.21'
gem 'pg_lock'
gem 'puma', '~> 3.12'
gem 'redis', '~> 3.3.5'
gem 'bcrypt', '~> 3.1.7'
gem 'money-rails'
gem 'responders', '~> 3.0'
gem 'aws-sdk-s3'
gem 'aws-sdk-sqs'
gem 'resque'
gem 'rollbar'
gem 'faraday_middleware'
gem 'json', '~> 2.1.0'
gem 'rails_semantic_logger'
gem 'activerecord-nulldb-adapter', '~> 0.4.0'
gem 'mini_magick'
gem 'paper_trail'
gem 'activejob-uniqueness'

# == Instrumentation
gem 'stackdriver', group: [:development, :production]

# == UTILITY

gem 'meta-tags'
gem 'gravatar_image_tag'
gem 'active_model_serializers', '~> 0.10.10'
gem 'aws-ses', '~> 0.4.4'
gem 'carrierwave'
gem 'counter_culture'
gem 'faker'
gem 'fog-aws'
gem 'graphql', '~> 1.9.18'
gem 'graphql-errors'
gem 'groupdate'
gem 'paperclip'
gem 'paperclip-meta'
gem 'delayed_paperclip'
gem 'phashion'
gem 'paranoia'
gem 'premailer-rails'
gem 'ranked-model'
gem 'ledermann-rails-settings'
gem 'redcarpet'
gem 'ruby-progressbar', require: false
gem 'scoped_search'
gem 'semantic'
gem 'sitemap_generator'
gem 'slack-notifier'
gem 'state_machines'
gem 'state_machines-activerecord'
gem 'will_paginate'
gem 'will_paginate-materialize', github: 'harrybournis/will_paginate-materialize'
gem 'pundit'
gem 'rest-client'

# == API

gem 'rswag-api'
gem 'rswag-ui'

# == INTEGRATIONS

gem 'ruby-trello'
gem 'stripe'
gem 'webpush'
gem 'her'
gem 'sentry-raven'
gem 'sendgrid-actionmailer'
gem "google-cloud-storage", "~> 1.11", require: false
gem 'xivapi', git: 'https://github.com/Refsheet/xivapi-ruby.git', branch: 'extended-character'
gem 'recaptcha'

# == MAINTENANCE

gem 'puma_worker_killer', require: false
gem 'table_print'
gem 'httplog', '~> 1.1.1'

# == PRODUCTION GEMS

group :production, :staging do
  gem 'active_record_slave'
end

# == NON PRODUCTION GEMS

group :development, :test do
  gem 'bullet'
  gem 'byebug', platform: :mri
  gem 'codecov', require: false
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'letter_opener'
  gem 'rack_session_access'
  gem 'rspec-collection_matchers', require: false
  gem 'rspec-expectations', require: false
  gem 'rspec-its', require: false
  gem 'rspec-rails', '~> 4.0.0.beta'
  gem 'rspec-retry', require: false
  gem 'rspec_junit_formatter', require: false
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 2.8'
  gem 'simplecov'
  gem 'yard'
  gem 'timecop'
  gem 'webmock'
  gem 'derailed_benchmarks'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  gem 'rswag-specs'
end

group :nocircle do
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate'
  gem 'graphiql-rails'
end
