# == Schema Information
#
# Table name: advertisement_slots
#
#  id                   :integer          not null, primary key
#  active_campaign_id   :integer
#  reserved_campaign_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  last_impression_at   :datetime
#
# Indexes
#
#  index_advertisement_slots_on_active_campaign_id    (active_campaign_id)
#  index_advertisement_slots_on_last_impression_at    (last_impression_at)
#  index_advertisement_slots_on_reserved_campaign_id  (reserved_campaign_id)
#

class Advertisement::Slot < ApplicationRecord
  belongs_to :active_campaign, class_name: "Advertisement::Campaign"
  belongs_to :reserved_campaign, class_name: "Advertisement::Campaign"

  scope :active, -> { where.not active_campaign_id: nil }
  scope :reserved, -> { where.not reserved_campaign_id: nil }
  scope :available, -> { where active_campaign_id: nil }
  scope :reservable, -> { where reserved_campaign_id: nil }
  scope :inactive, -> { available.reservable }

  scope :impression_order, -> { order <<-SQL }
    CASE
      WHEN active_campaign_id IS NOT NULL THEN 0
      WHEN reserved_campaign_id IS NOT NULL THEN 1
      ELSE 2
    END ASC,
 
    CASE
      WHEN last_impression_at IS NULL THEN 0
      ELSE 1
    END ASC, 

    last_impression_at ASC, 
    id ASC
  SQL

  # Returns the next active slot, in round-robin order.
  #
  def self.next
    self.active.impression_order.first
  end

  def self.next!
    self.next or raise ActiveRecord::RecordNotFound.new 'No ad slots currently active.'
  end

  # Expands available advertisement slots by +n+ slots.
  #
  def self.add(n)
    n.times do
      self.create
    end
  end

  # Removes +n+ slots from the available slot pool.
  #
  # @note This will only remove inactive slots, if
  #       there are any available.
  #
  def self.remove(n)
    self.where(id: self.inactive.last(n).pluck(:id)).delete_all
  end

  # Adjusts amount to equal +n+ slots. See ::contract! for
  # caveats on removing slots.
  #
  def self.adjust_to(n)
    count = n - self.count
    return if count == 0

    if count > 0
      self.add count
    else
      self.remove 0 - count
    end
  end

  # Inserts a campaign into rotation.
  #
  def self.assign(campaign, reserve=false)
    scope = if reserve
              self.reservable
            else
              self.inactive
            end

    available_ids = scope.pluck(:id)

    if available_ids.length < campaign.slots_requested
      return false

    else
      length = available_ids.length
      selected = []

      0.upto(campaign.slots_requested - 1) do |i|
        j = (i * length.to_f / campaign.slots_requested).ceil
        selected << available_ids[j]
      end

      r = self.where(id: selected).each do |slot|
        if reserve
          slot.reserve! campaign
        else
          slot.assign! campaign
        end
      end

      campaign.update_slot_counts
      r
    end
  end

  def self.reserve(campaign)
    self.assign campaign, true
  end


  #== Lifecycle Management

  # Assign a campaign to the slot. Will return false if
  # this slot is currently active.
  #
  def assign(campaign)
    return false if self.active?

    self.update active_campaign: campaign,
                           last_impression_at: nil
  end

  def assign!(campaign)
    self.assign campaign or raise "Attempt to assign #{campaign} to active slot #{self} failed."
  end

  def active?
    self.active_campaign_id.present?
  end

  def reserve(campaign)
    return false if self.reserved?

    self.update reserved_campaign: campaign
  end

  def reserve!(campaign)
    self.reserve campaign or raise "Attempt to reserve #{campaign} to reserved slot #{self} failed."
  end

  def reserved?
    self.reserved_campaign_id.present?
  end

  # Expires the current slot, removing the active campaign
  # and resetting the reserved ID. If an ad is reserved,
  # that campaign will now run.
  #
  def expire
    self.update active_campaign_id: self.reserved_campaign_id,
                           reserved_campaign_id: nil,
                           last_impression_at: nil
  end

  def inactive?
    self.active_campaign_id.blank? and self.reserved_campaign_id.blank?
  end


  #== Impressive.

  def set_impression
    self.update last_impression_at: Time.zone.now
  end
end
