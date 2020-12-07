class ImagePhashJob < ApplicationJob
  def perform(image)
    image.reload

    Raven.breadcrumbs.record do |crumb|
      crumb.category = "ImagePhashJob"
      crumb.level = :info

      crumb.data = {
          image_id: image.id,
          image_guid: image.guid,
          image_file_name: image.image_file_name,
          image_deleted_at: image.deleted_at
      }
    end

    Rails.logger.tagged 'ImagePhashJob' do
      extension = File.extname(image.image_file_name)
      basename = File.basename(image.image_file_name)
      tempfile = Tempfile.new([basename, extension])

      begin
        local = image.image.copy_to_local_file(nil, tempfile.path)
        phash = Phashion::Image.new(tempfile.path)

        hash = phash.fingerprint rescue 0
        bits = "%064b" % hash

        Rails.logger.info("Calculated pHash of #{image.guid} (#{image.image_file_name}): #{bits}")
        image.update(image_phash: bits)
      ensure
        tempfile.close
        tempfile.unlink
      end
    end
  end
end
