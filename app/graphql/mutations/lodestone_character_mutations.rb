module Mutations
  class LodestoneCharacterMutations < Mutations::ApplicationMutation
    before_action :get_character

    action :create do
      type Types::Lodestone::CharacterType

      argument :characterId, !types.ID
      argument :lodestoneId, !types.String
    end

    def create
      authorize Lodestone::Character
      @lodestone_character = Lodestone::ImportCharacterJob.perform_now character_id: @character.id,
                                                                       lodestone_id: lodestone_id_param
      @lodestone_character
    end

    action :update do
      type Types::Lodestone::CharacterType

      argument :characterId, !types.ID
    end

    def update
      @lodestone_character = @character.lodestone_character
      authorize @lodestone_character
      @lodestone_character = Lodestone::ImportCharacterJob.perform_now lodestone_character_id: @lodestone_character.id
      @lodestone_character
    end

    action :delete do
      type Types::Lodestone::CharacterType

      argument :characterId, !types.ID
    end

    def delete
      raise "WHY WOULD YOU EVER LEAVE US?"
    end

    private

    def lodestone_id_param
      id = params[:lodestoneId]
      # Example: https://na.finalfantasyxiv.com/lodestone/character/19875893/
      if id =~ %r{/character/(\d+)}i
        id = $1
      end
      id
    end

    def get_character
      @character = Character.find_by!(guid: params[:characterId])
      authorize @character, :update?
    end
  end
end