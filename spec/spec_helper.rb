require 'simplecov'

unless Rails.env.test?
  abort "This isn't a test environment!"
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
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.include ActiveJob::TestHelper

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.order = :random
  Kernel.srand config.seed
end
