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

class StripeBankAccount < BankAccount
  attr_accessor :bank_account_token

  validates_presence_of :account_holder_name
  validates_inclusion_of :account_holder_type, in: %w(individual company)

  before_validation :create_stripe_account

  def get_processor_account
    Stripe::BankAccount.retrieve self.processor_id
  end

  private

  def create_stripe_account
    seller  = self.user.seller.get_processor_account
    seller.external_account = self.bank_account_token
    seller.save

    account = seller.external_accounts.data.first

    self.assign_attributes processor_id: account.id,
                           account_holder_name: account.account_holder_name,
                           account_holder_type: account.account_holder_type,
                           bank_name: account.bank_name,
                           country: account.country,
                           currency: account.currency,
                           account_last_4: account.last4,
                           status: account.status
  end
end
