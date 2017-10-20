# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string
#  username            :string
#  email               :string
#  password_digest     :string
#  profile             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  settings            :json
#  type                :string
#  auth_code_digest    :string
#  parent_user_id      :integer
#  unconfirmed_email   :string
#  email_confirmed_at  :datetime
#
# Indexes
#
#  index_users_on_parent_user_id  (parent_user_id)
#  index_users_on_type            (type)
#

require 'rails_helper'

describe User, type: :model do
  it_is_expected_to(
    have_many: [
      :characters,
      :transfers_in,
      :transfers_out,
      :permissions,
      :roles,
      :visits,
      :pledges,
      :favorites
    ],
    have_one: [
      :patron,
      :invitation
    ],
    validate_presence_of: [
      :username,
      :email
    ],
  )

  its(:settings) { is_expected.to be_a HashWithIndifferentAccess }

  describe 'mailers' do
    let(:user) { build :user, :send_emails }

    it 'sends welcome email' do
      expect(UserMailer).to receive(:welcome).and_call_original
      user.save!
    end
  end

  it 'handles email changed' do
    expect(UserMailer).to receive(:welcome).and_call_original
    expect(UserMailer).to receive(:email_changed).and_call_original
    user = create :user, :send_emails
    old_email = user.email
    new_email = 'test2@example.com'

    user.update_attributes email: new_email
    expect(user.email).to eq old_email
    expect(user.unconfirmed_email).to eq new_email

    user.confirm!
    expect(user.email).to eq new_email
  end
end
