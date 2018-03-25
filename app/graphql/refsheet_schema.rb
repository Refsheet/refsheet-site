RefsheetSchema = GraphQL::Schema.define do
  use GraphQL::Subscriptions::ActionCableSubscriptions

  resolve_type -> (_type, _obj, _ctx) {}

  mutation Types::MutationType
  query Types::QueryType
  subscription Types::SubscriptionType
end

GraphQL::Errors.configure(RefsheetSchema) do
  rescue_from ActiveRecord::RecordNotFound do |ex|
    GraphQL::ExecutionError.new ex.message
  end

  # rescue_from StandardError do |ex|
  #   Rails.logger.error ex
  #   GraphQL::ExecutionError.new ex.message
  # end
end
