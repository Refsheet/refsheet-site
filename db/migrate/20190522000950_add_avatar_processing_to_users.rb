class AddAvatarProcessingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avatar_processing, :boolean
  end
end
