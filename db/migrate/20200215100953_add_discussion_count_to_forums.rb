class AddDiscussionCountToForums < ActiveRecord::Migration[6.0]
  def change
    add_column :forums, :discussions_count, :integer, default: 0, null: false
    add_column :forums, :members_count, :integer, default: 0, null: false
    add_column :forums, :posts_count, :integer, default: 0, null: false
  end
end
