# Reprocesses images that have not been processed within the last hour:
#
class ImageRedriveJob < ApplicationJob
  def perform(deep: false, skip_pending: false)
    unless skip_pending
      Image.processing.where('images.image_updated_at < ?', 1.hour.ago).limit(1000).each do |img|
        Rails.logger.info("Reprocessing image #{img.guid} (#{img.id})", image_updated_at: img.image_updated_at)
        img.image.reprocess!
      end
    end

    if deep
      require 'net/http'
      cloud = Net::HTTP.new('cloud.refsheet.net', 443)
      cloud.use_ssl = true

      Image.processed.order(created_at: :desc).find_each do |img|
        res = cloud.request_head(img.image.path)
        if res.code != 200
          Rails.logger.info("Image #{img.guid} (#{img.id}) corrupt, reprocessing...")
          img.image.reprocess!
        else
          Rails.logger.info("Image #{img.guid} (#{img.id}) OK")
        end
      end
    end
  end
end