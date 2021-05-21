module Mutations
  class ArtistMutations < ApplicationMutation
    before_action :get_artist, only: [:show]

    action :index, :paginated do
      type Types::ArtistsCollectionType
      # ApplicationMutation.pagination_args!(self)
    end

    def index
      paginate(Artist.all)
    end

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
