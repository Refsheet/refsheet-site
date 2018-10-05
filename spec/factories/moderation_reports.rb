# == Schema Information
#
# Table name: moderation_reports
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  sender_user_id   :integer
#  moderatable_id   :integer
#  moderatable_type :string
#  violation_type   :string
#  comment          :text
#  dmca_source_url  :string
#  status           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_moderation_reports_on_moderatable_id    (moderatable_id)
#  index_moderation_reports_on_moderatable_type  (moderatable_type)
#  index_moderation_reports_on_sender_user_id    (sender_user_id)
#  index_moderation_reports_on_status            (status)
#  index_moderation_reports_on_user_id           (user_id)
#  index_moderation_reports_on_violation_type    (violation_type)
#

FactoryBot.define do
  factory :moderation_report do
    association(:sender, factory: :user)
    association(:moderatable, factory: :image)
    violation_type { 'dmca' }
  end
end
