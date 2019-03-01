class Mutations::ConversationMutations < Mutations::ApplicationMutation
  before_action :get_conversation, only: [:update]

  action :create do
    type Types::ConversationType

    argument :recipient_id, !types.ID
    argument :subject, types.String
  end

  def create
    sender = context.current_user.call
    recipient = User.find(params[:recipient_id])

    @conversation = Conversation.with(sender, recipient)

    unless @conversation.persisted?
      @conversation.update_attributes(conversation_params)
    end

    @conversation
  end

  action :update do
    type Types::ConversationType

    argument :conversation_id, !types.ID
    argument :read, types.Boolean
  end

  def update
    if params[:read]
      @conversation.read_by! context.current_user.call
    end

    @conversation
  end

  private

  def get_conversation
    @conversation = Conversation.find_by! guid: params[:conversation_id]
  end

  def conversation_params
    params.permit(:subject)
  end
end
