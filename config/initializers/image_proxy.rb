Rails.application.configure do
  Rails.configuration.x.image_proxy = config_for(:image_proxy).with_indifferent_access
end
puts 'Initializing config/initializers/image_proxy.rb'
