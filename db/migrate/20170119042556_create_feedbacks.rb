class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.string :name
      t.string :email
      t.text :comment
      t.string :trello_card_id
      t.string :source_url
      t.integer :visit_id

      t.timestamps
    end
  end
end
