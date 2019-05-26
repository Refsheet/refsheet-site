# Reprocesses images that have not been processed within the last hour:
#
class ImageRedriveJob < ApplicationJob
  def perform
    Image.processing.where('images.image_updated_at < ?', 1.hour.ago).limit(1000).each do |img|
      Rails.logger.info("Reprocessing image #{img.guid} (#{img.id})", image_updated_at: img.image_updated_at)
      img.image.reprocess!
    end
  end
end