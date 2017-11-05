source 'https://rubygems.org'

# ruby '2.3.0' # or 2.3.1 or something

# == BACK END

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'redis', '~> 3.0'
gem 'bcrypt', '~> 3.1.7'
gem 'therubyracer'
gem 'money-rails'
gem 'responders'
gem 'ahoy_matey'
gem 'aws-sdk'
gem 'resque'
gem 'non-stupid-digest-assets'
gem 'rollbar'
gem 'active_elastic_job'

# == FRONT END

gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 5.0'
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

# == UTILITY

gem 'simple_form'
gem 'state_machines'
gem 'state_machines-activerecord'
gem 'active_model_serializers'
gem 'paranoia'
gem 'scoped_search'
gem 'will_paginate'
gem 'will_paginate-materialize', github: 'harrybournis/will_paginate-materialize'
gem 'faker'
gem 'slack-notifier'
gem 'ranked-model'
gem 'carrierwave'
gem 'fog-aws'
gem 'aws-ses', '~> 0.4.4'
gem 'paperclip'
gem 'dropzonejs-rails'
gem 'redcarpet'
gem 'sitemap_generator'
gem 'groupdate'
gem 'counter_culture'
gem 'premailer-rails'

# == INTEGRATIONS

gem 'ruby-trello'
gem 'stripe'

# == BOWER ASSETS

source 'https://rails-assets.org' do
  # gem 'rails-assets-highcharts'
  gem 'rails-assets-tinyColorPicker'
end

# == MAINTENANCE

gem 'puma_worker_killer'

# == NON PRODUCTION GEMS

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'rspec-expectations'
  gem 'rspec-collection_matchers'
  gem 'shoulda-matchers', '~> 2.8'
  gem 'simplecov'
  gem 'rack_session_access'
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'bullet'
  gem 'rspec-its'
  gem 'timecop'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'rspec_junit_formatter'
end

gem 'resque-web', require: 'resque_web'

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
