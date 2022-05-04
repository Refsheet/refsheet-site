class Mutations::MessageMutations < Mutations::ApplicationMutation
  action :create do
    type Types::MessageType

    argument :conversationId, types.ID
    argument :recipientId, types.ID
    argument :message, !types.String
  end

  def create
    if params[:conversationId]
      @conversation = Conversation.find_by!(guid: params[:conversationId])
    else
      sender = context.current_user.call
      recipient = User.find_by!(guid: params[:recipientId])

      @conversation = Conversation.with(sender, recipient)
      authorize @conversation, :create?
      @conversation.tap(&:save!)
    end

    @message = @conversation.messages.new message_params
    authorize @message, :create?
    @message.tap(&:save!)
  end

  private

  def message_params
    params.permit(:message)
          .merge(user: context.current_user.call)
  end
end
