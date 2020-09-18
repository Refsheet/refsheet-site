class ImageProcessingJob < ApplicationJob
  def perform(image)
    Rails.logger.tagged 'ImageProcessingJob' do
      image.image.process_delayed!
    end
  end
end
