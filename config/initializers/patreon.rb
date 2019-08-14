Rails.application.configure do
  Rails.configuration.x.patreon = config_for(:patreon)
end
puts 'Initializing config/initializers/patreon.rb'
