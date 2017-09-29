class CreateFeedbackReplies < ActiveRecord::Migration[5.0]
  def change
    create_table :feedback_replies do |t|
      t.integer :feedback_id
      t.integer :user_id
      t.text :comment

      t.timestamps
    end

    add_index :feedback_replies, :feedback_id
    add_index :feedback_replies, :user_id
  end
end
