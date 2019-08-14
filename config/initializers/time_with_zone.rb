class ActiveSupport::TimeWithZone
  def as_json(options = {})
    to_i
  end
end
puts 'Initializing config/initializers/time_with_zone.rb'
