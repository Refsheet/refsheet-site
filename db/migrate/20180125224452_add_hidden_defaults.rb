class AddHiddenDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column :characters, :hidden, :boolean, default: false
    change_column :images, :hidden, :boolean, default: false

    reversible do |dir|
      dir.up do
        Character.unscoped.where(hidden: nil).update_all hidden: false
        Image.unscoped.where(hidden: nil).update_all hidden: false
      end
    end
  end
end
