class ActiveSupport::TimeWithZone
  def as_json(options = {})
    to_i
  end
end
