class GraphqlController < ApplicationController
  include GraphqlHelper

  skip_before_filter :verify_authenticity_token

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    context = {
      current_user: current_user,
      current_user_id: current_user&.id,
      sign_out: method(:sign_out),
      sign_in: method(:sign_in)
    }

    result = RefsheetSchema.execute(query,
                                    variables: variables,
                                    context: context,
                                    operation_name: operation_name)

    render json: result
  end
end
