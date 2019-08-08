class ArtistsController < ApplicationController
  before_action :get_artist, only: [:show]

  def index
    eager_load artists: filter_scope(Artist.all)
    render 'application/show'
  end

  def show
    eager_load artist: @artist
    render 'application/show'
  end

  private

  def get_artist
    @artist = Artist.lookup!(params[:id])
  end
end