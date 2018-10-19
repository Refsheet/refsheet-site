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
#  done           :boolean
#  freshdesk_id   :string
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

  it 'tells freshdesk', :webmock do
    Freshdesk.configure do |config|
      config.domain = "refsheet"
      config.api_key = "x"
    end

    stub = stub_request(:post, Freshdesk.instance.endpoint_url + "/tickets").
            to_return(status: 200, body: '{"id":"fd-test-1"}')

    expect(Freshdesk::Ticket).to receive(:from_feedback).and_call_original
    feedback = create :feedback, :freshdesk
    expect(feedback.freshdesk_id).to eq "fd-test-1"
    expect(stub).to have_been_requested
  end
end
