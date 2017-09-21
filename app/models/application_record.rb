class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  after_validation :log_validation_errors

  def pluck(*attrs)
    attrs.collect do |attr|
      self.send attr
    end
  end

  private

  def log_validation_errors
    Rails.logger.tagged self.class.name do
      if self.errors.empty?
        Rails.logger.debug "Record is valid: #{self.inspect}"
        Rails.logger.debug '- Changes:'
        self.changes.each { |k,c| Rails.logger.debug "  * #{k}: #{c.collect(&:inspect).join(' => ')}" }
      else
        Rails.logger.warn "Record is invalid: #{self.inspect}"
        Rails.logger.warn '- Failed validation:'
        self.errors.full_messages.each { |m| Rails.logger.info "  * #{m}" }
      end
    end
  end
end
