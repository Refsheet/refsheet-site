class ImagePhashJob < ApplicationJob
  def perform(image)
    Rails.logger.tagged 'ImagePhashJob' do
      extension = File.extname(image.image_file_name)
      basename = File.basename(image.image_file_name)
      tempfile = Tempfile.new([basename, extension])

      begin
        local = image.image.copy_to_local_file(nil, tempfile.path)
        phash = Phashion::Image.new(tempfile.path)
        hash = phash.fingerprint
        Rails.logger.info("Calculated pHash of #{image.guid} (#{image.image_file_name}): #{hash}")
        image.update_attributes(image_phash: hash.to_s(2))
      ensure
        tempfile.close
        tempfile.unlink
      end
    end
  end
end