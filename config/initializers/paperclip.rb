Rails.application.configure do
  config.paperclip_defaults = {
      storage: :s3,
      s3_protocol: :https,
      s3_credentials: Rails.configuration.x.amazon
  }

  Paperclip.interpolates :guid do |attachment, _|
    attachment.instance.guid
  end
end
