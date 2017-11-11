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
#  amount_cents       :integer          default("0"), not null
#  amount_currency    :string           default("USD"), not null
#  slots_filled       :integer
#  guid               :string
#  status             :string
#  starts_at          :datetime
#  ends_at            :datetime
#  recurring          :boolean
#  total_impressions  :integer
#  total_clicks       :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  slots_requested    :integer          default("1")
#
# Indexes
#
#  index_advertisement_campaigns_on_guid     (guid)
#  index_advertisement_campaigns_on_user_id  (user_id)
#

class Advertisement::Campaign < ApplicationRecord
  include HasGuid

  belongs_to :user
  has_many :active_slots, class_name: Advertisement::Slot, foreign_key: :active_campaign_id
  has_many :reserved_slots, class_name: Advertisement::Slot, foreign_key: :reserved_campaign_id

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
      transition :pending => :assigned
    end
  end


  def update_slot_counts
    self.update_attributes slots_filled: self.active_slots.count
  end

  private

  def reserve_slot
    Advertisement::Slot.reserve self
  end
end
