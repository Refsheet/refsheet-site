module HasGuid
  extend ActiveSupport::Concern

  included do
    before_validation :generate_guid
    before_validation :downcase_guid
    class_attribute :guid_column_name
    class_attribute :guid_options

    validate :validate_guid

    after_initialize do
      if self.persisted? and
          self.has_attribute? guid_column_name and
          self.send(guid_column_name).blank?
        generate_guid && self.save!
      end
    end

    self.guid_column_name = :guid
    self.guid_options = {}
  end

  def to_param
    self.send(self.guid_column_name)
  end

  module ClassMethods
    # Assigns a GUID on +guid_column_name+ which will be unique within global scope and created before validation.
    #
    # Options:
    #   +scope+ (Symbol) - The scope of uniqueness to ensure.
    #   +type+ (String) - One of 'token', 'uuid' or nil for default (hex string)
    #   +length+ (Integer) - The length of the GUID to generate. Not valid for UUID
    #
    def has_guid(guid_column_name=:guid, options={})
      self.guid_column_name = guid_column_name
      self.guid_options = options

      validates_format_of self.guid_column_name,
                          with: /\A[^\s?&=.+]+\z/i,
                          message: 'can not contain spaces, or: ? & = . +',
                          allow_blank: true
    end

    # def find(id)
    #   if id.is_a? String
    #     self.find_by!(self.guid_column_name => id)
    #   else
    #     self.find_by!(id: id)
    #   end
    # end
  end

  private

  def guid_scope
    guid_options[:scope] ? {guid_options[:scope] => self.send(guid_options[:scope])} : '1=1'
  end

  def generate_guid
    return unless self.respond_to? guid_column_name
    return true unless self.send(guid_column_name).blank?

    begin
      guid = case guid_options[:type]&.to_s
        when 'token'
          SecureRandom.urlsafe_base64(guid_options[:length] || 8)
        when 'uuid'
          SecureRandom.uuid
        else
          SecureRandom.hex(guid_options[:length] || 8)
      end

      self.assign_attributes(guid_column_name => guid)
    end while self.class.unscoped.where(guid_scope).exists?(guid_column_name => self.send(guid_column_name))

    true
  end

  def validate_guid
    if self.send(guid_column_name).blank?
      self.errors[guid_column_name] << "can't be blank"
    end

    if self.class.where(guid_scope).where.not(id: self.id).exists?(guid_column_name => self.send(guid_column_name).downcase)
      self.errors[guid_column_name] << 'has already been taken'
    end

    if self.errors[guid_column_name].any?
      Rails.logger.info "GUID Errors: #{self.errors[guid_column_name].inspect}"
      return true
    end

    false
  end

  def downcase_guid
    self.assign_attributes(guid_column_name => self.send(guid_column_name).to_s.downcase)
  end
end
