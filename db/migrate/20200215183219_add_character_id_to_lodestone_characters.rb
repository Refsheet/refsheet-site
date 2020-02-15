class AddCharacterIdToLodestoneCharacters < ActiveRecord::Migration[6.0]
  def change
    add_reference :lodestone_characters, :character, foreign_key: true
  end
end
