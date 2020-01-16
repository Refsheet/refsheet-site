require 'simplecov'

ENV['NODE_ENV'] = ENV['RACK_ENV'] = ENV['RAILS_ENV']

unless Rails.env.test?
  raise "This isn't a test environment!"
end

require 'rspec-rails'
require 'rspec/collection_matchers'
require 'rspec/its'
require 'rspec/expectations'
require 'rspec/retry'
require 'rspec_junit_formatter'

SimpleCov.start 'rails' do
  add_filter '/spec/'
end

if ENV['CIRCLECI'] || ENV['CI']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
  puts "CI environment initialized."

  puts ENV.to_h.to_yaml
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.order = :random
  Kernel.srand config.seed
end
