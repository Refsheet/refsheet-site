Rails.application.configure do
  Rails.configuration.x.amazon = HashWithIndifferentAccess.new(config_for(:aws))

  # CarrierWave.configure do |config|
  #   config.cache_dir = "#{Rails.root}/tmp"
  #   # config.permissions = 0666
  #   # config.delete_tmp_file_after_storage = false
  #
  #   config.fog_credentials = {
  #       :fog_provider               => 'AWS',
  #       :aws_access_key_id      => Rails.application.config.x.amazon[:access_key_id],
  #       :aws_secret_access_key  => Rails.application.config.x.amazon[:secret_access_key],
  #       :fog_directory => Rails.application.config.x.amazon[:bucket],
  #       :fog_region => Rails.application.config.x.amazon[:s3_region]
  #   }
  #
  #   config.storage = :fog
  # end
end
