class Mutations::ProfileWidgetMutations < Mutations::ApplicationMutation
  before_action :get_widget, only: [:update]
  before_action :get_character, only: [:create]

  action :update do
    type Types::WidgetType

    argument :id, !types.ID
    argument :title, types.String
    argument :data, types.String
    argument :row_order_position, types.String
  end

  def update
    @widget.update_attributes! widget_params
    @widget
  end

  action :create do
    type Types::WidgetType

    argument :characterId, !types.ID
    argument :sectionId, !types.ID
    argument :columnId, !types.ID
    argument :type, !types.String
  end

  def create
    authorize_premium_feature! params[:type]

    @section = @character.profile_sections.find(params[:sectionId])

    @widget = @section.widgets.create(
        widget_type: params[:type],
        column: params[:columnId],
        character: @character
    )
  end

  private

  def widget_params
    p = params.permit(:title, :data, :row_order_position)

    begin
      p[:data] = JSON.parse(p[:data]) if p[:data]
    rescue JSON::ParserError => e
      Rails.logger.warn(e)
    end

    p
  end

  def get_widget
    @widget = Characters::ProfileWidget.find params[:id]
    authorize! @widget.character.managed_by? current_user
  end

  def get_character
    @character = Character.find_by!(shortcode: params[:characterId])
    authorize! @character.managed_by? current_user
  end

  def authorize_premium_feature!(type)
    required_level = Characters::ProfileWidget.premium_level(type)
    current_user.supporter_level.authorize! required_level
  end
end
