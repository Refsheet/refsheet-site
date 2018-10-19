class Mutations::MessageMutations < Mutations::ApplicationMutation
  action :create do
    type Types::MessageType

    argument :conversationId, types.ID
    argument :recipientId, types.ID
    argument :message, !types.String
  end

  def create
    Conversation.transaction do
      if params[:conversationId]
        @conversation = Conversation.find_by!(guid: params[:conversationId])
      else
        sender = context.current_user
        recipient = User.find(params[:recipientId])

        @conversation = Conversation.with(sender, recipient).tap(&:save!)
      end

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
