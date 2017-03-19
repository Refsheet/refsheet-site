module CollectionHelper
  def report_range
    start = params[:start].present? ? DateTime.parse(params[:start]) : Time.zone.now.at_beginning_of_month
    stop  = params[:end].present?   ? DateTime.parse(params[:end])   : start.at_end_of_month
    (start.at_beginning_of_day..stop.at_end_of_day)
  end

  def report_range_display
    same_month = report_range.begin.month == report_range.end.month
    same_year  = report_range.begin.year  == report_range.end.year
    full_month = report_range.begin.day == 1 &&
        report_range.end.day == report_range.end.at_end_of_month.day &&
        same_month &&
        same_year

    text  = report_range.begin.strftime '%B'
    text += report_range.begin.strftime ' %d' unless full_month
    text += report_range.begin.strftime ', %Y' unless same_year
    text += ' -' unless full_month
    text += report_range.end.strftime ' %B'  unless same_month
    text += report_range.end.strftime ' %d, '  unless full_month
    text +  report_range.end.strftime(' %Y')
  end

  def report_count(scope, filter_param = :created_at)
    scope = scope.where(filter_param => report_range)
    scope.count
  end

  def report_group(scope, filter_param = :created_at)
    group  = (params[:interval]&.downcase || 'day')
    scope = scope.where(filter_param => report_range)

    if %w(hour day week month year).include? group
      scope = scope.group_by_period(group, filter_param, range: report_range, default_value: 0, format: "%b %d")
    end

    scope
  end

  def taper_group(items, default_sort = 'created_at')
    items.sort_by do |item|
      item.send(default_sort)
    end.reverse.group_by do |item|
      case item.send(default_sort)
        when -> (i) { i > Time.zone.today.at_beginning_of_day }
          "Today"
        when -> (i) { i.between? Time.zone.today.at_beginning_of_week.at_beginning_of_day, Time.zone.yesterday.at_end_of_day }
          "This Week"
        when -> (i) { i.between? Time.zone.today.at_beginning_of_month.at_beginning_of_day, (Time.zone.today.at_beginning_of_week.at_beginning_of_day - 1.second) }
          "This Month"
        else
          "Older"
      end
    end
  end

  def filter_scope(scope, default_sort = 'created_at', default_order = 'desc')
    unpermitted_params = []

    params[:sort]  ||= default_sort
    params[:order] ||= default_order

    params.keys.each do |key|
      relation, column = key.to_s.split('.')
      value = params[key].dup
      negate = value[0] == '!'
      value.slice!(0) if negate
      value = [nil, ''] if value.blank? || value == '!'

      if column.nil?
        column   = relation
        relation = scope.table_name
      end

      table = relation.pluralize

      if scope.connection.table_exists?(table) && scope.connection.column_exists?(table, column)
        if table != scope.table_name
          if scope.reflect_on_association(relation)
            scope = scope.joins(relation.to_sym)
          else
            unpermitted_params << key
          end
        end

        if negate
          scope = scope.where.not("#{table}.#{column}" => value)
        else
          scope = scope.where("#{table}.#{column}" => value)
        end
      end
    end

    if params.include?(:q) or params.include?(:sort)
      sort = params[:sort] ? "#{params[:sort].try(:downcase)} #{params[:order].try(:downcase)}".strip : ''

      if scope.respond_to?(:search_for) && params[:q]
        scope = scope.search_for(params[:q])
      else
        unpermitted_params << 'q' if params[:q]
      end

      scope = scope.order(sort)
    end

    unless params[:page] == 'all' || !scope.respond_to?(:page)
      scope = scope.page(params[:page] || 1)
    end

    raise ActionController::UnpermittedParameters.new(unpermitted_params) if unpermitted_params.any?

    scope
  rescue ScopedSearch::QueryNotSupported => e
    raise ActionController::RoutingError.new(e.message)
  end
end
