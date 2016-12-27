source 'https://rubygems.org'

# ruby '2.3.0' # or 2.3.1 or something

# == BACK END

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'redis', '~> 3.0'
gem 'bcrypt', '~> 3.1.7'
gem 'therubyracer'
gem 'responders'
gem 'ahoy_matey'

# == FRONT END

gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.2'
gem 'haml'
gem 'react-rails', github: 'reactjs/react-rails', branch: 'master'
gem 'materialize-sass'

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

# == BOWER ASSETS

source 'https://rails-assets.org' do
  # gem 'rails-assets-highcharts'
end

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
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'annotate'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
