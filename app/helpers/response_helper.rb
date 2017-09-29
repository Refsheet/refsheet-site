module ResponseHelper
  def api_collection_response(collection, options={})
    root = options.delete :root
    options.merge! scope: view_context

    results = ActiveModel::SerializableResource.new(collection, options).as_json

    { json: {
        root => results,
        '$meta' => {
            page: params[:page] || 1,
            total: collection.total_entries,
            per_page: collection.per_page,
            pages: collection.total_pages
        }
    }}
  end
end
