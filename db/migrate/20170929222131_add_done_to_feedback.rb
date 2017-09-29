class AddDoneToFeedback < ActiveRecord::Migration[5.0]
  def change
    add_column :feedbacks, :done, :boolean
  end
end
