module Admin
  class ArtistsController < AdminController
    before_action :find_artist, only: [:show, :edit, :update]

    before_action do
      @search = { path: admin_artists_path }
    end

    def index
      @artists = @scope = filter_scope Artist
    end

    def show

    end

    def edit
    end

    def new
      @artist = Artist.new
    end

    def create
      @artist = Artist.new artist_params

      if @artist.save
        redirect_to admin_artist_path(@artist.slug)
      else
        render 'new', status: :bad_request
      end
    end

    def update
      if @artist.update artist_params
        redirect_to admin_artist_path(@artist.slug)
      else
        render 'edit', status: :bad_request
      end
    end

    private

    def artist_params
      if params[:artist][:username].present?
        user = User.lookup(params[:artist][:username])
        if user.nil?
          @artist.errors.add :username, "does not exist"
        end
      else
        user = nil
      end

      params
          .require(:artist)
          .permit(
              :name,
              :slug,
              :avatar,
              :locked,
              :user,
              :profile,
              :commission_info,
              :commission_url,
              :website_url
          )
          .merge(
              user: user
          )
    end

    def find_artist
      @artist = Artist.lookup!(params[:id])
    end
  end
end
