source 'https://rubygems.org'

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
gem 'execjs'
gem 'money-rails'
gem 'responders', '~> 3.0'
gem 'ahoy_matey'
gem 'aws-sdk-s3'
gem 'aws-sdk-sqs'
gem 'resque'
gem 'non-stupid-digest-assets'
gem 'rollbar'
gem 'webpacker'
gem 'faraday_middleware'
gem 'json', '~> 2.1.0'
gem 'rails_semantic_logger'
gem 'activerecord-nulldb-adapter', '~> 0.4.0'
gem 'mini_magick'
gem 'paper_trail'

# == FRONT END

gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 6.0'
gem 'coffee-rails', '~> 4.2'
gem 'haml'
gem 'react-rails', github: 'reactjs/react-rails', branch: 'master'
gem 'materialize-sass', '~> 1.0.0'

gem 'rails-ujs'
gem 'turbolinks', '~> 5'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'jquery-masonry-rails'
gem 'autoprefixer-rails'
gem 'font-awesome-sass'
gem 'meta-tags'
gem 'gravatar_image_tag'
gem 'chartkick'
gem 'breadcrumbs_on_rails'
gem 'jquery-tmpl-rails'
gem 'jquery-justified-gallery-rails'
gem 'imagesLoaded_rails'
gem 'highcharts-rails'
gem 'js_cookie_rails'
gem 'serviceworker-rails'

# == UTILITY

gem 'active_model_serializers', '~> 0.10.10'
gem 'aws-ses', '~> 0.4.4'
gem 'carrierwave'
gem 'counter_culture'
gem 'dropzonejs-rails'
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
gem 'ruby-progressbar'
gem 'scoped_search'
gem 'semantic'
gem 'simple_form'
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

# == BOWER ASSETS

source 'http://insecure.rails-assets.org' do
  # gem 'rails-assets-highcharts'
  gem 'rails-assets-tinyColorPicker'
end

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
  gem 'capybara'
  gem 'capybara-selenium'
  gem 'webdrivers'
  gem 'codecov', require: false
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'rack_session_access'
  gem 'rspec-collection_matchers', require: false
  gem 'rspec-expectations', require: false
  gem 'rspec-its', require: false
  gem 'rspec-rails', '~> 4.0.0.beta', require: false
  gem 'rspec-retry', require: false
  gem 'rspec_junit_formatter', require: false
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 2.8'
  gem 'simplecov'
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
