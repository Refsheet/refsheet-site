class ApplicationRecord < ActiveRecord::Base
  include ApplicationHelper

  self.abstract_class = true

  before_validation :hack_out_null_values
  after_validation :log_validation_errors

  def pluck(*attrs)
    attrs.collect do |attr|
      self.send attr
    end
  end

  def self.random
    order("RANDOM()").first
  end

  private

  # Rollbar #496
  def hack_out_null_values
    self.class.columns.each do |col|
      if col.type == :text
        original = self.attributes[col.name]
        self.assign_attributes col.name => original&.gsub("\u0000", '') if original.respond_to? :gsub
      end
    end
  end

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

  def method_missing(symbol, *args)
    if symbol.to_s =~ /^is_(\w+)$/
      self.send($1 + '?', *args)
    else
      super
    end
  end

  def trigger!(*args)
    RefsheetSchema.subscriptions.trigger(*args)
  end
end
