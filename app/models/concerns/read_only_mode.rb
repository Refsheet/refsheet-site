module ReadOnlyMode
  extend ActiveSupport::Concern

  included do
    before_save :check_read_only!
    before_destroy :check_read_only!
  end

  private

  def check_read_only!
    return unless ENV['RAILS_READ_ONLY'] == 'true'
    raise ActiveRecord::ReadOnlyRecord, "#{self.class.name} is read-only during migration"
  end
end
