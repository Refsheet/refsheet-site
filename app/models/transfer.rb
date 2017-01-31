# == Schema Information
#
# Table name: transfers
#
#  id                  :integer          not null, primary key
#  character_id        :integer
#  item_id             :integer
#  sender_user_id      :integer
#  destination_user_id :integer
#  invitation_id       :integer
#  seen_at             :datetime
#  claimed_at          :datetime
#  rejected_at         :datetime
#  status              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Transfer < ApplicationRecord
  belongs_to :character
  belongs_to :item
  belongs_to :sender, class_name: User, foreign_key: :sender_user_id
  belongs_to :destination, class_name: User, foreign_key: :destination_user_id
  belongs_to :invitation

  state_machine :status, initial: :pending do
    state :sent
    state :rejected
    state :claimed

    event :deliver do
      transition :pending => :sent
    end

    event :claim do
      transition :sent => :claimed
    end

    event :reject do
      transition :sent => :rejected
    end
  end
end
