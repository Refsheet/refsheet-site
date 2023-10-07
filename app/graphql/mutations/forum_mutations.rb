module Mutations
  class ForumMutations < ApplicationMutation
    action :index do
      type types[Types::ForumType]
    end

    def index
      return []
      Forum.all
    end

    action :show do
      type Types::ForumType

      argument :slug, !types.String
    end

    def show
      return nil
      Forum.find_by(slug: params[:slug])
    end

    action :create do
      type Types::ForumType
    end

    def create

    end

    action :update do
      type Types::ForumType
    end

    def update

    end
  end
end
