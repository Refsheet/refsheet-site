class Mutations::ProfileWidgetMutations < Mutations::ApplicationMutation
  before_action :get_widget

  action :update do
    type Types::WidgetType

    argument :id, !types.ID
    argument :title, types.String
    argument :data, types.String
  end

  def update
    @widget.update_attributes! widget_params
    @widget
  end

  private

  def widget_params
    p = params.permit(:title, :data)

    begin
      p[:data] = JSON.parse(p[:data])
    rescue JSONError => e
      Rails.logger.warn(e)
    end

    p
  end

  def get_widget
    @widget = Characters::ProfileWidget.find params[:id]
    authorize! @widget.character.managed_by? current_user
  end
end
