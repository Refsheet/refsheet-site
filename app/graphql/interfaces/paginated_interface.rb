Interfaces::PaginatedInterface = GraphQL::InterfaceType.define do
  name 'Paginated'

  field :count, types.Int do
    resolve -> (scope, _args, _ctx) {
      scope.count
    }
  end

  field :offset, types.Int do
    resolve -> (scope, _args, _ctx) {
      if scope.respond_to? :current_page
        scope.offset
      end
    }
  end

  field :totalEntries, types.Int do
    resolve -> (scope, _args, _ctx) {
      if scope.respond_to? :total_entries
        scope.total_entries
      end
    }
  end

  field :currentPage, types.Int do
    resolve -> (scope, _args, _ctx) {
      if scope.respond_to? :current_page
        scope.current_page
      end
    }
  end

  field :perPage, types.Int do
    resolve -> (scope, _args, _ctx) {
      if scope.respond_to? :per_page
        scope.per_page
      end
    }
  end

  field :totalPages, types.Int do
    resolve -> (scope, _args, _ctx) {
      if scope.respond_to? :total_pages
        scope.total_pages
      end
    }
  end
end
