# == Schema Information
#
# Table name: ahoy_visits
#
#  id               :integer          not null, primary key
#  visit_token      :string
#  visitor_token    :string
#  ip               :string
#  user_agent       :text
#  referrer         :text
#  landing_page     :text
#  user_id          :integer
#  referring_domain :string
#  search_keyword   :string
#  browser          :string
#  os               :string
#  device_type      :string
#  screen_height    :integer
#  screen_width     :integer
#  country          :string
#  region           :string
#  city             :string
#  postal_code      :string
#  latitude         :decimal(, )
#  longitude        :decimal(, )
#  utm_source       :string
#  utm_medium       :string
#  utm_term         :string
#  utm_content      :string
#  utm_campaign     :string
#  started_at       :datetime
#
# Indexes
#
#  index_ahoy_visits_on_user_id      (user_id)
#  index_ahoy_visits_on_visit_token  (visit_token) UNIQUE
#

class Ahoy::Visit < ApplicationRecord
  self.table_name = "ahoy_visits"

  has_many :events, class_name: "Ahoy::Event"
  belongs_to :user, optional: true

  def location
    return unless country.present?
    [city, region, country].join(', ')
  end
end
