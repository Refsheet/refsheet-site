class ImageProcessingJob < ApplicationJob
  def perform(image)
    Rails.logger.tagged 'ImageProcessingJob' do
      image.image.reprocess!
    end
  end
end
