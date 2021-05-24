class ImageProcessingJob < ApplicationJob
  queue_as :refsheet_image_processing
  unique :until_executed, on_conflict: :log

  def perform(image)
    Rails.logger.tagged 'ImageProcessingJob' do
      image.image.process_delayed!
    end
  end
end
