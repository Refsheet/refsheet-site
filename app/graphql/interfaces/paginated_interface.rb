Interfaces::PaginatedInterface = GraphQL::InterfaceType.define do
  name 'Paginated'

  field :count, types.Int do
    resolve -> (scope, _args, _ctx) {
      scope.count
    }
  end

  field :offset, types.Int do
    resolve -> (scope, _args, _ctx) {
      scope.offset
    }
  end

  field :totalEntries, types.Int do
    resolve -> (scope, _args, _ctx) {
      scope.total_entries
    }
  end

  field :currentPage, types.Int do
    resolve -> (scope, _args, _ctx) {
      scope.current_page
    }
  end

  field :perPage, types.Int do
    resolve -> (scope, _args, _ctx) {
      scope.per_page
    }
  end

  field :totalPages, types.Int do
    resolve -> (scope, _args, _ctx) {
      scope.total_pages
    }
  end
end