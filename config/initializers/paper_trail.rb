Rails.application.configure do
  # HACK: It seems like the model isn't being picked up in development mode unless this
  #       require statement is here. Otherwise, it defaults to the old class.
  require_relative '../../app/models/paper_trail/version'
end