Rails.application.configure do
  Rails.configuration.x.trello = config_for(:trello)

  Trello.configure do |config|
    config.developer_public_key = Rails.configuration.x.trello['api_key']
    config.member_token = Rails.configuration.x.trello['token']
  end
end
puts 'Initializing config/initializers/trello.rb'
