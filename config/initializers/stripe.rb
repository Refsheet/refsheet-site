Rails.application.configure do
  Rails.configuration.x.stripe = config_for :stripe
  Stripe.api_key = Rails.configuration.x.stripe['api_key']
end
puts 'Initializing config/initializers/stripe.rb'
