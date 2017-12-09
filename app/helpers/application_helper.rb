module ApplicationHelper
  def with(item)
    yield item if item
  end
end
