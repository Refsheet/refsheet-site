class ImageBackfillJob < ApplicationJob
  def perform
    Rails.logger.tagged 'ImageBackfillJob' do
      Rails.logger.info "Starting ImageBackfillJob"
      Image.where('images.image_phash IS NULL').first(1000).each do |image|
        Rails.logger.info("Backfill required for: " + image.guid)
        if image.image_phash.nil?
          ImagePhashJob.perform_later(image)
        end
      end
    end
  end
end