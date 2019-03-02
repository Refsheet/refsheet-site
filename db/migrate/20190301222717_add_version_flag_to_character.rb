class AddVersionFlagToCharacter < ActiveRecord::Migration[5.0]
  def change
    add_column :characters, :version, :integer, default: 1
  end
end
