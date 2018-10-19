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

class BankAccount < ApplicationRecord
  belongs_to :user

  validates_presence_of :user

  # @override this
  def get_processor_account
    nil
  end
end
