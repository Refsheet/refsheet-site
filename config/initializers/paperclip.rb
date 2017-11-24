Rails.application.configure do
  defaults = {
      storage: :s3,
      s3_protocol: :https,
      s3_credentials: Rails.configuration.x.amazon
      # s3_host_alias: Rails.configuration.x.amazon[:s3_host_alias],
      # url: ':s3_alias_url',
      # path: '/:class/:attachment/:id_partition/:style/:filename'
  }

  if ENV['CLOUD_DOMAIN']
    defaults.merge! s3_host_alias: ENV['CLOUD_DOMAIN'],
                    url: ':s3_alias_url'
  end

  config.paperclip_defaults = defaults

  Paperclip.interpolates :guid do |attachment, _|
    attachment.instance.guid
  end
end
