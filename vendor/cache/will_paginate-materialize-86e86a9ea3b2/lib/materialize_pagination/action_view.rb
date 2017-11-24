require "will_paginate/view_helpers/action_view"
require "materialize_pagination/materialize_renderer"

module MaterializePagination
  # A custom renderer class for WillPaginate that produces markup suitable for use with MaterializeCSS
  class Rails < WillPaginate::ActionView::LinkRenderer
    include MaterializeRenderer
  end
end
