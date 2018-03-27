class AddFreshdeskIdToFeedback < ActiveRecord::Migration[5.0]
  def change
    add_column :feedbacks, :freshdesk_id, :string
    add_column :feedback_replies, :freshdesk_id, :string
  end
end
