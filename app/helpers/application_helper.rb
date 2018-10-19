module ApplicationHelper
  def with(item, fallback=nil)
    if item
      yield item
    else
      fallback
    end
  end
end
