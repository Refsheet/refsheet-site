module NamespacedModel
  extend ActiveSupport::Concern

  included do
    def self.table_name
      self.name.delete('::').underscore.pluralize
    end
  end
end
