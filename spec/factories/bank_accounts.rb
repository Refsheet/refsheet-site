# == Schema Information
#
# Table name: bank_accounts
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  account_holder_name :string
#  account_holder_type :string
#  bank_name           :string
#  account_last_4      :string
#  country             :string           default("US")
#  currency            :string           default("USD")
#  status              :string
#  processor_id        :string
#  type                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_bank_accounts_on_type     (type)
#  index_bank_accounts_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :bank_account do
    user_id 1
    account_holder_name "MyString"
    account_holder_type "MyString"
    bank_name "MyString"
    account_last_4 "MyString"
    country "MyString"
    currency "MyString"
    status "MyString"
    processor_id "MyString"
  end
end
