# Reprocesses images that have not been processed within the last hour:
#
class ImageRedriveJob < ApplicationJob
  def perform(deep: false, skip_pending: false, deep_limit: nil, deep_start: nil)
    unless skip_pending
      Image.processing.where('images.image_updated_at < ?', 1.hour.ago).limit(1000).each do |img|
        ImageProcessingJob.perform_later(img)
      end

      ImageBackfillJob.perform_now
    end

    if deep
      require 'net/http'
      cloud = Net::HTTP.new('cloud.refsheet.net', 443)
      cloud.use_ssl = true

      scope = Image.processed.order(created_at: :desc)

      if deep_limit
        scope = scope.limit(deep_limit)
      end

      if deep_start
        scope = scope.where('images.id <= ?', deep_start)
      end

      scope.find_each do |img|
        res = cloud.request_head(img.image.path)
        if res.code != "200"
          Rails.logger.info("Image #{img.guid} (#{img.id}) corrupt, reprocessing...")
          img.image.update_columns(image_processing: true)
        else
          Rails.logger.info("Image #{img.guid} (#{img.id}) OK")
        end
      end
    end
  end
end
