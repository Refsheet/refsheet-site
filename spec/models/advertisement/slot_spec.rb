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
#  index_advertisement_slots_on_reserved_campaign_id  (reserved_campaign_id)
#

require 'rails_helper'

describe Advertisement::Slot, type: :model do
  it_is_expected_to(
      belong_to: [
          :active_campaign,
          :reserved_campaign
      ]
  )

  let(:active_slots) { create_list :advertisement_slot, 2, :active }
  let(:reserved_slots) { create_list :advertisement_slot, 2, :reserved }
  let(:inactive_slots) { create_list :advertisement_slot, 2 }
  let(:all_slots) { active_slots + reserved_slots + inactive_slots}


  #== Class

  describe '::next' do
    let!(:all_slots) { active_slots + reserved_slots + inactive_slots }

    it { expect(Advertisement::Slot.next).to eq active_slots.first }

    context 'with date' do
      before { active_slots.first.set_impression }
      it { expect(Advertisement::Slot.next).to eq active_slots.second }
    end
  end

  it 'assigns round-robin' do
    active_slots
    inactive_slots = create_list :advertisement_slot, 4
    campaign = create :advertisement_campaign, slots_requested: 2

    expect(Advertisement::Slot.assign campaign).to be_truthy
    expect(campaign.active_slots.pluck(:id)).to match_array [inactive_slots[0].id, inactive_slots[2].id]
    expect(campaign.slots_filled).to eq 2
  end

  it 'reserves round-robin' do
    all_slots
    campaign = create :advertisement_campaign, slots_requested: 2

    expect(Advertisement::Slot.reserve campaign).to be_truthy
    expect(campaign.reserved_slots.pluck(:id)).to match_array [all_slots[0].id, all_slots[4].id]
    expect(campaign.slots_filled).to eq 0
  end

  it 'fails assignment when no room' do
    active_slots
    campaign = create :advertisement_campaign, slots_requested: 2

    expect(Advertisement::Slot.assign campaign).to be_falsey
    expect(Advertisement::Slot.reserve campaign).to be_truthy
  end

  it 'adds slots' do
    inactive_slots
    Advertisement::Slot.add 4
    expect(Advertisement::Slot.count).to eq 6
  end

  it 'removes slots' do
    active_slots
    expect(Advertisement::Slot.remove(1)).to eq 0
    expect(Advertisement::Slot.count).to eq 2
  end

  it 'adjusts up' do
    inactive_slots
    Advertisement::Slot.adjust_to 3
    expect(Advertisement::Slot.count).to eq 3
  end

  it 'adjusts down' do
    all_slots
    expect(Advertisement::Slot.adjust_to 1).to eq 2
    expect(Advertisement::Slot.count).to eq 4
  end


  #== Instance

  it 'cycles on reserved' do
    slot = create :advertisement_slot, :reserved, :active
    ac1 = slot.active_campaign

    expect(slot.expire).to be_truthy
    ac2 = slot.reload.active_campaign

    expect(ac1).to_not eq ac2
    expect(slot).to_not be_reserved
    expect(slot).to be_active
    expect(slot).to_not be_inactive
  end
end
