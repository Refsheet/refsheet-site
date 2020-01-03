Rails.application.configure do
  Rails.configuration.x.amazon = HashWithIndifferentAccess.new(config_for(:aws))

  defaults = {
      storage: :s3,
      s3_protocol: :https,
      s3_credentials: Rails.configuration.x.amazon
  }

  if ENV['CLOUD_DOMAIN']
    defaults.merge! url: ':s3_alias_url', s3_host_alias: ENV['CLOUD_DOMAIN'],
                    path: '/:class/:attachment/:id_partition/:style/:filename'
  end

  if Rails.env.test?
    defaults.merge! storage: :filesystem
  end

  config.paperclip_defaults = defaults

  Paperclip.interpolates :guid do |attachment, _|
    attachment.instance.guid
  end

  config.delayed_paperclip_defaults = {
      queue: :refsheet_image_processing
  }
end

class DelayedPaperclip::ProcessJob < ActiveJob::Base
  def perform(instance_klass, instance_id, attachment_name)
    DelayedPaperclip.process_job(instance_klass, instance_id, attachment_name.to_sym)

    begin
      instance_klass.constantize.unscoped.find(instance_id).send(:delayed_complete)
    rescue => e
      Rails.logger.error(e)
    end
  end
end