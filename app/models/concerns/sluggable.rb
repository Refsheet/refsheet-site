module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug
    class_attribute :slug_options
    class_attribute :slug_source

    self.slug_source  = :name
    self.slug_options = {}

    validates_format_of :slug,
                        with: /\A[a-z0-9-]+\z/i,
                        message: 'can only contain a-z, 0-9 and -',
                        allow_blank: true
  end

  def to_param
    self.slug
  end

  module ClassMethods
    def slugify(source_column, options = {})
      self.slug_source  = source_column
      self.slug_options = options

      validates_uniqueness_of :slug, scope: self.slug_options[:scope], case_sensitive: false

      if options[:lookups]
        define_singleton_method :lookup do |slug|
          self.find_by 'LOWER(' + self.table_name + '.slug) = ?', slug&.to_s&.downcase
        end

        define_singleton_method :lookup! do |*args|
          self.lookup(*args) or raise ActiveRecord::RecordNotFound.new "Couldn't find #{self.class.name} with slug #{args[0]}.", self.class
        end
      end
    end
  end

  private

  def generate_slug
    return true unless self.slug.blank?

    slug_scope = slug_options[:scope] ? {slug_options[:scope] => self.send(slug_options[:scope])} : '1=1'

    count = 0

    begin
      self.slug = to_slug(self.send(slug_source), count > 0 ? count : nil)
      count += 1
    end while self.class.where(slug_scope).exists?(slug: self.slug)

    true
  end

  def to_slug(string, tail=nil)
    return if string.nil?
    slug = string.downcase.gsub(/[^a-z0-9-]+/, '-').gsub(/^-+|-+$/, '')
    slug = [slug, tail].join('-') if tail
    slug
  end
end
