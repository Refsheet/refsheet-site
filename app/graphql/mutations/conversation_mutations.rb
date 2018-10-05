class Mutations::ConversationMutations < Mutations::ApplicationMutation
  action :create do
    type Types::ConversationType

    argument :recipient_id, !types.ID
    argument :subject, types.String
  end

  def create
    sender = context.current_user
    recipient = User.find(params[:recipient_id])

    @conversation = Conversation.with(sender, recipient)

    unless @conversation.persisted?
      @conversation.update_attributes(conversation_params)
    end

    @conversation
  end

  private

  def conversation_params
    params.permit(:subject)
  end
end
