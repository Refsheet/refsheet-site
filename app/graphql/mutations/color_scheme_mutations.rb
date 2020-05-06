module Mutations
  class ColorSchemeMutations < Mutations::ApplicationMutation
    action :update do
      type Types::ThemeType

      argument :id, !types.ID
      argument :name, types.String
      argument :colorData, Types::ThemeColorDataInputType
    end

    def update
      @color_scheme = ColorScheme.find_by!(guid: params[:id])
      authorize @color_scheme

      @color_scheme.assign_attributes(update_params)
      @color_scheme.merge params[:colorData].permit!
      @color_scheme.save!
      @color_scheme
    end

    action :create do
      type Types::ThemeType

      argument :characterId, types.ID
      argument :name, types.String
      argument :colorData, Types::ThemeColorDataInputType
    end

    def create
      if params[:characterId].present?
        @character = current_user.characters.find_by!(guid: params[:characterId])
        authorize @character, :update?
      end

      @color_scheme = ColorScheme.default
      authorize @color_scheme, :create?

      @color_scheme.assign_attributes(create_params)
      @color_scheme.merge params[:colorData].permit!
      @color_scheme.save!

      if @character
        @character.color_scheme = @color_scheme
        @character.save
      end

      @color_scheme
    end

    private

    def update_params
      params.permit(:name)
    end

    def create_params
      params.permit(:name)
          .merge(user: current_user)
    end
  end
end