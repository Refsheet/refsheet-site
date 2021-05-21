class CharacterDestructionJob < ApplicationJob
  def perform(character)
    character.destroy
  end
end
