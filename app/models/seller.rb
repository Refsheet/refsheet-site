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

class Seller < ApplicationRecord
  belongs_to :user, inverse_of: :seller

  validates_presence_of :user
  validates_uniqueness_of :user_id

  # @override this.
  def get_processor_account
    nil
  end
end
