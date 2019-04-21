RefsheetSchema = GraphQL::Schema.define do
  use GraphQL::Subscriptions::ActionCableSubscriptions

  resolve_type -> (_type, _obj, _ctx) {}

  mutation Types::MutationType
  query Types::QueryType
  subscription Types::SubscriptionType
end

GraphQL::Errors.configure(RefsheetSchema) do
  rescue_from ActiveRecord::RecordNotFound do |ex|
    # maybe return nil instead?
    GraphQL::ExecutionError.new ex.message
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    error_messages = e.record.errors.full_messages.to_sentence
    GraphQL::ExecutionError.new "Validation failed: #{error_messages}."
  end

  rescue_from StandardError do |e|
    Rails.logger.error e
    Rails.logger.error e.backtrace.join("\n")
    Raven.capture_exception(e)
    GraphQL::ExecutionError.new e.message
  end
end

class ActionCable::Connection::Subscriptions
  def execute_command(data)
    case data['command']
    when 'subscribe'   then add data
    when 'unsubscribe' then remove data
    when 'message'     then perform_action data
    else
      logger.error "Received unrecognized command in #{data.inspect}"
    end
  rescue Exception => e
    raise e
    logger.error "Could not execute command from #{data.inspect}) [#{e.class} - #{e.message}]: #{e.backtrace.first(5).join(" | ")}"
  end
end