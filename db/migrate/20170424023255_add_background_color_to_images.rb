class AddBackgroundColorToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :background_color, :string, after: :source_url
  end
end
