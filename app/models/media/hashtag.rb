class Media::Hashtag < ApplicationRecord
  include NamespacedModel

  def self.[](tag)
    find_or_initialize_by tag: tag
  end
end
