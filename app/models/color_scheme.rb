# == Schema Information
#
# Table name: color_schemes
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer
#  color_data :text
#  guid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ColorScheme < ApplicationRecord
  include HasGuid

  COLOR_MATCH = /\A((rgb|hsl)a?\((\s*[\d.]+,?){3,4}\s*\)|#?([a-f0-9]{3}|[a-f0-9]{6}|[a-f0-9]{8}))\z/i

  belongs_to :user
  has_many :characters

  validate :validate_color_data

  has_guid
  serialize :color_data

  def self.default
    new color_data: {
        primary: "#80cbc4",
        accent1: "#26a69a",
        accent2: "#ee6e73",
        text: "rgba(255,255,255,0.9)",
        textMedium: "rgba(255,255,255,0.5)",
        textLight: "rgba(255,255,255,0.3)",
        background: "#262626",
        cardBackground: "#212121",
        cardHeaderBackground: "rgba(0,0,0,0.2)",
        imageBackground: "#000000",
        border: "rgba(255,255,255,0.1)",
    }
  end

  def color_data
    (super || {}).with_indifferent_access
  end

  def [](key)
    super || get_color(key)
  end

  def get_color(key)
    self.color_data ||= {}
    color = color_data.fetch(normalize_key(key), nil)
    color
  end

  def set_color(key, value)
    self.color_data ||= {}
    normalized = normalize_color(value)
    attributes['color_data'][normalize_key(key)] = normalized
    normalized
  end

  def method_missing(method, *args)
    key = method.to_s.gsub(/=$/, '')

    if (color = get_color(key))
      if method =~ /=$/
        return set_color(key, args[0])
      end

      return color
    end


    super
  end

  private

  def normalize_key(key)
    normalized = key.to_s.gsub('-', '_').camelize(:lower).to_sym
    normalized
  end

  def normalize_color(color)
    color
  end

  def validate_color_data
    if color_data.is_a? Hash
      color_data.collect do |k, v|
        unless v.match COLOR_MATCH
          self.errors.add k.to_sym, 'Must be RGB, HSL or Hex code.'
        end
      end
    else
      self.errors.add :color_data, 'Malformed :('
    end
  end
end
