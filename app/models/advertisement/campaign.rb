# == Schema Information
#
# Table name: advertisement_campaigns
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  title              :string
#  caption            :string
#  link               :string
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  amount_cents       :integer          default(0), not null
#  amount_currency    :string           default("USD"), not null
#  slots_filled       :integer          default(0)
#  guid               :string
#  status             :string
#  starts_at          :datetime
#  ends_at            :datetime
#  recurring          :boolean          default(FALSE)
#  total_impressions  :integer          default(0)
#  total_clicks       :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  slots_requested    :integer          default(0)
#
# Indexes
#
#  index_advertisement_campaigns_on_guid     (guid)
#  index_advertisement_campaigns_on_user_id  (user_id)
#

class Advertisement::Campaign < ApplicationRecord
  include HasGuid

  attr_accessor :current_slot_id

  belongs_to :user
  has_many :active_slots, class_name: "Advertisement::Slot", foreign_key: :active_campaign_id
  has_many :reserved_slots, class_name: "Advertisement::Slot", foreign_key: :reserved_campaign_id

  validates :title, presence: true,
            length: { maximum: 30 }

  validates :caption, presence: true,
            length: { maximum: 90 }

  validates :link, presence: true,
            format: {
                with: /\Ahttp(s)?:\/\/\S+\z/,
                message: 'must be a URL, with no spaces, and HTTP or HTTPS included'
            }

  has_attached_file :image,
                    path: '/our_friends/:guid/:style.:extension',
                    hash_secret: 'totally-not-an-advertisement-i-swear',
                    styles: {
                        small: ['100x75>', :png],
                        medium: ['200x150>', :png],
                        large: ['400x300>', :png]
                    }

  validates_attachment :image,
                       content_type: { content_type: /image\/*/ },
                       size: { in: 0..5.megabytes }

  has_guid
  monetize :amount_cents


  state_machine :status, initial: :pending do
    before_transition :pending => :reserved, do: [:reserve_slot]
    before_transition :pending => :active, do: [:assign_slot]

    state :reserved
    state :active
    state :expired

    event :reserve do
      transition :pending => :reserved
    end

    event :assign do
      transition :pending => :active
    end
  end


  #== Hacked Relations

  def impression_events
    Ahoy::Event.where(name: 'advertisement.impression').where_properties(advertisement_id: self.guid)
  end

  def click_events
    Ahoy::Event.where(name: 'advertisement.click').where_properties(advertisement_id: self.guid)
  end


  #== Utility

  def slug
    (self.created_at || Time.zone.now).strftime('%Y') + '-' + self.guid.to_s
  end

  def ctr
    (self.total_clicks.to_f / self.total_impressions.to_f).round(3)
  rescue
    0
  end

  def generate_link
    utm_params = {
        utm_source: 'refsheet.net',
        utm_campaign: self.slug,
        utm_medium: 'paid-media',
        utm_content: 'newsfeed-sidebar'
    }

    uri = URI(self.link)
    uri.query = [uri.query, utm_params.to_param].compact.join('&')
    uri.to_s
  end


  #== Lifecycle

  def update_slot_counts
    self.update_attributes slots_filled: self.active_slots.count
  end

  def record_impression(slot_id)
    self.update_attributes total_impressions: self.impression_events.count
    Rails.logger.info "Updating slot #{slot_id}..."
    self.active_slots.find_by(id: slot_id)&.set_impression
  end

  def record_click
    self.update_attributes total_clicks: self.click_events.count
  end

  private

  def reserve_slot
    Advertisement::Slot.reserve self
  end

  def assign_slot
    Advertisement::Slot.assign self
  end
end
