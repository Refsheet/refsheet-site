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
    search_query = ''

    if (query = params[:q]).present?
      search = []

      query.split(/\s+/).each do |part|
        if part =~ /\A(\w+):(\S+)\z/
          cmd = $1.downcase.to_sym

          case cmd
            when :is
              params[$2.downcase.to_sym] = 'true'
            when :not
              params[$2.downcase.to_sym] = 'false'
            else
              params[cmd] = $2
          end
        else
          search << part
        end
      end

      search_query = search.join(' ')
    end

    params.keys.each do |key|
      relation, column = key.to_s.split('.')
      value = params[key].dup
      negate = value[0] == '!'
      value.slice!(0) if negate
      value = [nil, ''] if value.blank? || value == '!'
      value = [nil, false] if value.is_a? String and value.downcase == 'false'
      value = nil if value.is_a? String and value.downcase == 'null'

      if column.nil?
        column   = relation
        relation = scope.table_name
      end

      table = relation.pluralize

      if scope.connection.data_source_exists?(table) && scope.connection.column_exists?(table, column)
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

    if search_query.present? or params.include?(:sort)
      sort = if params[:sort]
               if params[:sort] =~ /\A\w+\z/
                 "#{scope.table_name + '.' + params[:sort].try(:downcase)} #{params[:order].try(:upcase)}".strip
               else
                 "#{params[:sort]} #{params[:order].try(:upcase)}".strip
               end
             else
               ''
             end

      if search_query.present?
        if scope.respond_to?(:search_for)
          scope = scope.search_for(search_query)
        else
          unpermitted_params << 'q'
        end
      end

      scope = scope.order(sort)
    end

    unless params[:page] == 'all' || !scope.respond_to?(:page)
      scope = scope.paginate(page: params[:page] || 1, per_page: params[:per_page] || 24)
    end

    raise ActionController::UnpermittedParameters.new(unpermitted_params) if unpermitted_params.any?

    scope
  rescue ScopedSearch::QueryNotSupported => e
    raise ActionController::RoutingError.new(e.message)
  end
end
