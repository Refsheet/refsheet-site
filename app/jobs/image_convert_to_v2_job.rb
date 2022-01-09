class ImageConvertToV2Job < ApplicationJob
  def perform(image)
    if image.upload.attached?
      return
    end

    Rails.logger.tagged "ImageConvertToV2Job" do
      extension = File.extname(image.image_file_name)
      basename = File.basename(image.image_file_name)
      tempfile = Tempfile.new([basename, extension])

      begin
        image.image.copy_to_local_file(nil, tempfile.path)
        Rails.logger.info("Downloaded file to: #{tempfile.path}")
        image.upload.attach(io: File.open(tempfile.path), filename: image.image_file_name)
      ensure
        tempfile.close
        tempfile.unlink
      end
    end
  end
end
