class AddAttributesToCharacter < ActiveRecord::Migration[5.0]
  class ::Character < ApplicationRecord
    serialize :custom_attributes
  end

  def change
    add_column :characters, :custom_attributes, :text

    reversible do |dir|
      dir.up do
        ::Character.find_each do |c|
          puts '- Updating ' + c.id.to_s + ' ' + c.name

          #  height            :string
          #  weight            :string
          #  body_type         :string
          #  personality       :string

          attr = [
              { id: 'gender', name: 'Gender', value: c.gender },
              { id: 'height', name: 'Height / Weight', value: c.height },
              { id: 'body-type', name: 'Body Type', value: c.body_type }
          ]

          c.update_attributes custom_attributes: attr
          puts '  -> DONE: ' + attr.inspect
        end
      end
    end
  end
end
