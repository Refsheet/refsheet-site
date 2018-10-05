class Mutations::MessageMutations < Mutations::ApplicationMutation
  action :create do
    type Types::MessageType

    argument :recipient_id, !types.ID
    argument :message, types.String
  end

  def create
    sender = context.current_user
    recipient = User.find(params[:recipient_id])

    Conversation.transaction do
      @conversation = Conversation.with(sender, recipient).tap(&:save!)
      @message = @conversation.messages.create! message_params
    end

    @message
  end

  private

  def message_params
    params.permit(:message)
          .merge(user: context.current_user)
  end
end
