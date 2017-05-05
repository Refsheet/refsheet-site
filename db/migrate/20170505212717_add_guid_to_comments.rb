class AddGuidToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :media_comments, :guid, :string
    add_index :media_comments, :guid
  end
end
