class GraphqlChannel < ApplicationCable::Channel
  include GraphqlHelper

  def subscribed
    @subscription_ids = []
  end

  def execute(data)
    query = data["query"]
    variables = ensure_hash(data["variables"])
    operation_name = data["operationName"]

    context = {
        current_user: method(:current_user),
        current_user_id: current_user&.id,
        channel: self
    }

    result = RefsheetSchema.execute query: query,
                                    context: context,
                                    variables: variables,
                                    operation_name: operation_name

    payload = {
        result: result.subscription? ? {} : result.to_h,
        more: result.subscription?,
    }

    # Track the subscription here so we can remove it
    # on unsubscribe.
    if result.context[:subscription_id]
      @subscription_ids << context[:subscription_id]
    end

    transmit(payload)
  end

  def unsubscribed
    @subscription_ids.each do |sid|
      RefsheetSchema.subscriptions.delete_subscription(sid)
    end
  end
end
