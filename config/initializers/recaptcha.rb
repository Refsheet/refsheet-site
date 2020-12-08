Rails.application.configure do
  Rails.configuration.x.recaptcha = config_for(:recaptcha)
end
