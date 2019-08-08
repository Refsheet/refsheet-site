# == Schema Information
#
# Table name: artists_edits
#
#  id             :integer          not null, primary key
#  guid           :string
#  user_id        :integer
#  summary        :string
#  changes        :text
#  approved_at    :datetime
#  approved_by_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_artists_edits_on_approved_by_id  (approved_by_id)
#  index_artists_edits_on_guid            (guid)
#  index_artists_edits_on_user_id         (user_id)
#

FactoryBot.define do
  factory :artists_edit, class: 'Artists::Edit' do
    guid { "MyString" }
    user { nil }
    summary { "MyString" }
    changes { "MyText" }
    approved_at { "2019-08-05 15:10:31" }
    approver_user { nil }
  end
end
