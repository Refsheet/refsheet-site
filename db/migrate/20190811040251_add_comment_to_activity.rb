class AddCommentToActivity < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :comment, :text
    add_reference :activities, :reply_to_activity, foreign_key: { to_table: :activities }
  end
end
