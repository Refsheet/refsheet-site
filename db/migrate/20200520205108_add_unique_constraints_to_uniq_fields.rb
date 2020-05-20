class AddUniqueConstraintsToUniqFields < ActiveRecord::Migration[6.0]
  def change
    # Remove Old
    remove_index :users, name: 'index_users_on_lower_username'
    remove_index :users, name: 'index_users_on_lower_email'
    remove_index :users, name: 'index_users_on_lower_unconfirmed_email'

    # Add Uniq
    add_index :users, 'LOWER(users.username) varchar_pattern_ops',
              name: 'index_users_on_lower_username',
              unique: true

    add_index :users, 'LOWER(users.email) varchar_pattern_ops',
              name: 'index_users_on_lower_email',
              unique: true

    add_index :users, 'LOWER(users.unconfirmed_email) varchar_pattern_ops',
              name: 'index_users_on_lower_unconfirmed_email',
              unique: true
  end
end
