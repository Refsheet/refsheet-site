class Mutations::ModerationMutations < Mutations::ApplicationMutation
  before_action :get_moderation

  action :update do
    type Types::ModerationType

    argument :id, !types.ID
    argument :resolution, !types.String
  end

  def update
    case params[:resolution]
      when 'auto_resolve'
        @moderation.auto_resolve!
      when 'dismiss'
        @moderation.dismiss!
    end

    @moderation
  end

  private

  def get_moderation
    # authorize! context.current_user.call&.role? Role::MODERATOR
    @moderation = ModerationReport.find params[:id]
  end
end
