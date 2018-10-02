class ImageProcessingJob < ApplicationJob
  def perform(image)
    Rails.logger.tagged 'ImageProcessingJob' do
      image.image.reprocess_without_delay!
    end
  end
end
