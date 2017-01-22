class ImageProcessingJob < ApplicationJob
  queue_as :default

  def perform(image)
    Rails.logger.tagged 'ImageProcessingJob' do
      image.image.reprocess!
    end
  end
end
