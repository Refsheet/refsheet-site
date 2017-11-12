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


require 'rails_helper'

describe Advertisement::Campaign, type: :model do
  it_is_expected_to(
      have_many: [
          :active_slots,
          :reserved_slots
      ],
      belong_to: [
          :user
      ],
      validate_presence_of: [
          :title,
          :caption,
          :link
      ],
      monetize: :amount_cents
  )

  describe '#generate_link' do
    let(:campaign) { create :advertisement_campaign, link: 'https://foo.com/bar?qux=baz' }
    subject { campaign.generate_link }

    it { is_expected.to match /bar\?qux=baz&utm_/ }

    context 'when no params' do
      let(:campaign) { create :advertisement_campaign, link: 'https://foo.com/bar' }
      it { is_expected.to match /bar\?utm_/ }
    end
  end
end
