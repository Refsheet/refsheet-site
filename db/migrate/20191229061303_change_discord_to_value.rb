class ChangeDiscordToValue < ActiveRecord::Migration[5.2]
  def change
    add_column :forum_karmas, :value, :integer, not_null: true, default: 1
  end
end
