module Mutations
  class ColorSchemeMutations < Mutations::ApplicationMutation
    action :update do
      type Types::ThemeType

      argument :id, !types.ID
      argument :colorData, Types::ThemeColorDataInputType
    end

    def update
      @color_scheme = ColorScheme.find_by!(guid: params[:id])
      authorize @color_scheme

      @color_scheme.color_data.merge! params[:colorData].permit!
      @color_scheme.save!
      @color_scheme
    end
  end
end