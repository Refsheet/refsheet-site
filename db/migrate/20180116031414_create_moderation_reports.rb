class CreateModerationReports < ActiveRecord::Migration[5.0]
  def change
    create_table :moderation_reports do |t|
      t.integer :user_id
      t.integer :sender_user_id
      t.integer :moderatable_id
      t.string :moderatable_type
      t.string :violation_type
      t.text :comment
      t.string :dmca_source_url
      t.string :status

      t.timestamps
    end

    add_index :moderation_reports, :user_id
    add_index :moderation_reports, :sender_user_id
    add_index :moderation_reports, :status
    add_index :moderation_reports, :violation_type
    add_index :moderation_reports, :moderatable_id
    add_index :moderation_reports, :moderatable_type
  end
end
