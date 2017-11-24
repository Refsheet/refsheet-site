Rails.application.configure do
  defaults = {
      storage: :s3,
      s3_protocol: :https,
      s3_credentials: Rails.configuration.x.amazon,
      path: '/:class/:attachment/:id_partition/:style/:filename'
  }

  if ENV['CLOUD_DOMAIN']
    defaults.merge! url: ':s3_alias_url', s3_host_alias: ENV['CLOUD_DOMAIN']
  end

  config.paperclip_defaults = defaults

  Paperclip.interpolates :guid do |attachment, _|
    attachment.instance.guid
  end
end
