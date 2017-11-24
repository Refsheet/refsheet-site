require 'materialize_pagination/view_helpers'

module MaterializePagination
  class Railtie < ::Rails::Railtie
    initializer "materialize_pagination.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end
