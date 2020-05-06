module Mutations
  class GuestbookEntryMutations < Mutations::ApplicationMutation
    before_action :get_character

    action :index do
      type types[Types::GuestbookEntryType]

      argument :characterId, !types.ID
      argument :page, types.Int
    end

    def index
      @character.guestbook_entries.page(params[:page] || 1)
    end

    action :create do
      type Types::GuestbookEntryType

      argument :characterId, !types.ID
      argument :message, !types.String
    end

    def create
      @guestbook_entry = @character.guestbook_entries.build create_params
      authorize @guestbook_entry
      @guestbook_entry.tap(&:save!)
    end
  end

  private

  def get_character
    @character = Character.find_by!(guid: params[:characterId])
  end

  def create_params
    params.require(:message).merge(author: current_user)
  end
end