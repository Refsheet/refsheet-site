Rails.application.configure do
  Rails.configuration.x.amazon = config_for(:aws)

  config.paperclip_defaults = {
      storage: :s3,
      s3_protocol: :https,
      s3_credentials: Rails.configuration.x.amazon
  }
end
