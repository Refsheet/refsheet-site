module GraphqlHelper
  def graphql_query(query, variables: nil, context: nil, operation_name: nil, allow_exceptions: false)
    result = RefsheetSchema.execute query,
                                    variables: variables,
                                    context: context,
                                    operation_name: operation_name

    data = result.as_json.with_indifferent_access

    # Rehydrate exceptions:
    unless allow_exceptions
      (data[:errors] || []).each do |err|
        if err[:extensions]&.include?(:error_type)
          klass = Object.const_get(err[:extensions][:error_type]) || Exception
          ex = klass.new(err[:extensions][:error_message])
          ex.set_backtrace err[:extensions][:backtrace]
          raise ex
        end
      end
    end

    data
  end
end
