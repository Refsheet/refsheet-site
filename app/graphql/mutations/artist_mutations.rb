module Mutations
  class ArtistMutations < ApplicationMutation
    before_action :get_artist, only: [:show]

    action :show do
      type Types::ArtistType

      argument :slug, !types.String
    end

    def show
      @artist
    end

    private

    def get_artist
      @artist = Artist.lookup!(params[:slug])
    end
  end
end