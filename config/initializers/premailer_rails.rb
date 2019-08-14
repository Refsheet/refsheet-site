Rails.application.configure do |config|
  options = {
      remove_scripts: false
  }

  Premailer::Rails.config.merge! options
end
puts 'Initializing config/initializers/premailer_rails.rb'
