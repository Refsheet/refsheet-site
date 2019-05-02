source 'https://rubygems.org'

# ruby '2.3.0' # or 2.3.1 or something

# == BACK END

gem 'rails', '~> 5.0.7'
gem 'rake', '~> 12.3.1'
gem 'rack-cors'
gem 'pg', '~> 0.21'
gem 'puma', '~> 3.0'
gem 'redis', '~> 3.3.5'
gem 'bcrypt', '~> 3.1.7'
gem 'execjs'
gem 'money-rails'
gem 'responders'
gem 'ahoy_matey'
gem 'aws-sdk-s3'
gem 'aws-sdk-sqs'
gem 'resque'
gem 'non-stupid-digest-assets'
gem 'rollbar'
gem 'active_elastic_job', github: 'tawan/active-elastic-job', branch: 'master'
gem 'sprockets_uglifier_with_source_maps'
gem 'webpacker'
gem 'faraday_middleware'
gem 'json', '~> 2.1.0'
gem 'ar-octopus'
gem 'ougai'
gem 'rainbow'

# == Google Cloud
gem 'google-cloud-logging'

# == FRONT END

gem 'uglifier', '>= 1.3.0'
gem 'sassc-rails'
gem 'coffee-rails', '~> 4.2'
gem 'haml'
gem 'react-rails', github: 'reactjs/react-rails', branch: 'master'
gem 'zreact-router-rails'
gem 'materialize-sass', github: 'sitehive/materialize-sass', branch: 'master'

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

gem 'active_model_serializers'
gem 'aws-ses', '~> 0.4.4'
gem 'carrierwave'
gem 'counter_culture'
gem 'dropzonejs-rails'
gem 'faker'
gem 'fog-aws'
gem 'graphql'
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
gem 'rest-client'

# == INTEGRATIONS

gem 'ruby-trello'
gem 'stripe'
gem 'webpush'
gem 'her'
gem 'sentry-raven'

# == BOWER ASSETS

source 'http://insecure.rails-assets.org' do
  # gem 'rails-assets-highcharts'
  gem 'rails-assets-tinyColorPicker'
end

# == MAINTENANCE

gem 'puma_worker_killer'
gem 'table_print'
gem 'httplog', '~> 1.1.1'

# == NON PRODUCTION GEMS

group :development, :test do
  gem 'bullet'
  gem 'byebug', platform: :mri
  gem 'capybara'
  gem 'capybara-selenium'
  gem 'chromedriver-helper'
  gem 'codecov', require: false
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'rack_session_access'
  gem 'rspec-collection_matchers'
  gem 'rspec-expectations'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'rspec-retry'
  gem 'rspec_junit_formatter'
  gem 'rails-controller-testing'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'shoulda-matchers', '~> 2.8'
  gem 'simplecov'
  gem 'timecop'
  gem 'webmock'
end

group :nocircle do
end

gem 'resque-web', require: 'resque_web'

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate'
  gem 'graphiql-rails'
end
