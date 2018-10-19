module HasDirectUpload
  extend ActiveSupport::Concern

  module ClassMethods
    def has_direct_upload(column, options={})
      url_column = column.to_s + '_direct_upload_url'
      bucket_name = options.fetch(:s3_bucket) { Rails.configuration.x.amazon[:bucket] }

      url_format = /\Ahttps:\/\/(?:#{bucket_name}\.s3\.amazonaws\.com|s3\.amazonaws\.com\/#{bucket_name})\/(?<path>.+\/(?<filename>[^\/]+))/

      define_method url_column + '=' do |value|
        url = (CGI.unescape(value) rescue nil)
        write_attribute url_column, url
        return unless url.present?

        set_upload_attributes column, bucket_name, url_format
        reprocess_required[column] = true
      end

      define_method column.to_s + '_presigned_post' do
        bucket = s3.bucket(bucket_name)

        file_path = options.fetch(:s3_upload_path) { "uploads/#{SecureRandom.hex}/${filename}" }

        Rails.logger.debug("Got bucket: #{bucket}")

        bucket.presigned_post key: file_path,
                              acl: 'authenticated-read',
                              success_action_status: '201',
                              content_type_starts_with: ''
      end

      after_commit do
        if reprocess_required[column]
          source = self.send(column.to_s + '_direct_upload_url').match url_format
          next unless source

          destination = self.send(column).path(:original).gsub /\A\//, ''
          source_path = source[:path]

          Rails.logger.info "\nMoving Upload:\n\t- #{source_path}\n\t+ #{destination}"

          obj = s3obj key: source_path, bucket_name: bucket_name

          Rails.logger.info "\t* #{obj.inspect}"
          Rails.logger.info "\t* #{obj.content_length} bytes"

          obj.copy_to key: destination,
                      bucket: bucket_name,
                      metadata: obj.metadata.to_h,
                      acl: 'authenticated-read'

          new = s3obj key: destination, bucket_name: bucket_name

          Rails.logger.info "\t* #{new.inspect}"
          Rails.logger.info "\t* #{new.content_length} bytes"

          enqueue_post_processing_for column
        end

        reprocess_required[column] = false
      end

      unless options[:allow_blank]
        validates url_column, presence: true, if: -> { send(column).nil? }
      end

      validates url_column,
                format: {
                    with: /\Ahttps:\/\/(?:#{bucket_name}\.s3\.amazonaws\.com|s3\.amazonaws\.com\/#{bucket_name})\//,
                    allow_blank: options[:allow_blank]
                },
                if: -> { send(column).nil? }
    end
  end

  def reprocess_required
    @reprocess_required ||= {}
  end

  private

  def set_upload_attributes(column, bucket_name, url_format)
    url_column = column.to_s + '_direct_upload_url'

    retry_count ||= 5
    direct_upload_url_data = url_format.match(self.send(url_column))

    return false unless direct_upload_url_data

    bucket = s3.bucket(bucket_name)
    s3_object = bucket.object(direct_upload_url_data[:path])

    self.assign_attributes(
        "#{column}_file_name" => direct_upload_url_data[:filename],
        "#{column}_file_size" => s3_object.content_length,
        "#{column}_content_type" => s3_object.content_type,
        "#{column}_updated_at" => s3_object.last_modified,
        "#{column}_processing" => true
    )
  rescue Aws::S3::Errors::NoSuchKey
    if (tries -= 1) > 0
      sleep 3
      retry
    else
      Rails.logger.debug '[HasDirectUpload#set_upload_attributes] Failed to find AWS object.'
      false
    end
  end

  def s3
    Aws::S3::Resource.new(
        region: Rails.configuration.x.amazon[:s3_region],
        credentials: Aws::Credentials.new(
            Rails.configuration.x.amazon[:access_key_id],
            Rails.configuration.x.amazon[:secret_access_key]
        )
    )
  end

  def s3obj(options={})
    opts = {
        region: Rails.configuration.x.amazon[:s3_region],
        credentials: Aws::Credentials.new(
            Rails.configuration.x.amazon[:access_key_id],
            Rails.configuration.x.amazon[:secret_access_key]
        )
    }.merge(options)

    Aws::S3::Object.new(opts)
  end
end
