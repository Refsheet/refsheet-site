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
end
