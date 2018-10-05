require 'database_cleaner'

RSpec.configure do |config|
  DELETE_TYPES = [:controller, :request]

  config.before(:suite) do
    DatabaseCleaner.clean_with :deletion
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do |ex|
    if DELETE_TYPES.include?(ex.metadata[:type]) or ex.metadata[:js]
      DatabaseCleaner.strategy = :deletion
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
