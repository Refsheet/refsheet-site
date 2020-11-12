class AddImageProcessingErrorToImages < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :image_processing_error, :text
  end
end
