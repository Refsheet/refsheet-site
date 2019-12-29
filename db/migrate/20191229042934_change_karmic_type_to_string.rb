class ChangeKarmicTypeToString < ActiveRecord::Migration[5.2]
  def change
    change_column :forum_karmas, :karmic_type, :string
  end
end
