# == Schema Information
#
# Table name: feedbacks
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  name           :string
#  email          :string
#  comment        :text
#  trello_card_id :string
#  source_url     :string
#  visit_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

describe Feedback, type: :model do
  it_is_expected_to(
    belong_to: [
      :user,
      :visit
    ],
    validate_presence_of: :comment
  )
  it 'tells trello' do
    expect_any_instance_of(Trello::Card).to receive(:save).and_return(true)

    f = Feedback.new name: 'Mau', comment: 'Is testing again.'
    f.save
  end
end
