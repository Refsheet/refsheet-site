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
#  image_file_size    :bigint
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
#  index_advertisement_campaigns_on_ends_at    (ends_at)
#  index_advertisement_campaigns_on_guid       (guid)
#  index_advertisement_campaigns_on_starts_at  (starts_at)
#  index_advertisement_campaigns_on_user_id    (user_id)
#

class Advertisement::CampaignSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :caption,
             :slug,
             :image_url,
             :link,
             :current_slot_id

  def id
    object.guid
  end

  def image_url
    {
        medium: object.image.url(:medium),
        large: object.image.url(:large)
    }
  end
end
