module GraphqlHelper
  def graphql_query(query, variables: nil, context: nil, operation_name: nil)
    result = RefsheetSchema.execute query,
                                    variables: variables,
                                    context: context,
                                    operation_name: operation_name

    result.as_json.with_indifferent_access
  end
end
