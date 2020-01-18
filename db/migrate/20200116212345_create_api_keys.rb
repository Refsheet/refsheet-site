class CreateApiKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :api_keys do |t|
      t.references :user, foreign_key: true
      t.string :guid
      t.string :secret_digest
      t.boolean :read_only, default: false
      t.string :name

      t.datetime :deleted_at
      t.timestamps
    end

    add_index :api_keys, :guid
  end
end
