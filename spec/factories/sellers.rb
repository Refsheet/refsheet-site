# == Schema Information
#
# Table name: sellers
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  type                :string
#  address_id          :integer
#  processor_id        :string
#  first_name          :string
#  last_name           :string
#  dob                 :datetime
#  tos_acceptance_date :datetime
#  tos_acceptance_ip   :string
#  default_currency    :string
#  processor_type      :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_sellers_on_type     (type)
#  index_sellers_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :seller do
    user_id 1
    type ""
    address_id 1
    processor_id "MyString"
    first_name "MyString"
    last_name "MyString"
    dob "2017-11-05 16:58:42"
    tos_acceptance_date "2017-11-05 16:58:42"
    tos_acceptance_ip "MyString"
    default_currency "MyString"
  end
end
