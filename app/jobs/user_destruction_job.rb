class UserDestructionJob < ApplicationJob
  def perform(user)
    user.characters.find_each do |character|
      CharacterDestructionJob.perform_now(character)
    end

    user.destroy
  end
end
