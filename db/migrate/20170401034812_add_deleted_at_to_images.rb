class AddDeletedAtToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :deleted_at, :datetime
  end
end
