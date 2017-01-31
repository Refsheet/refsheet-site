# == Schema Information
#
# Table name: characters
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  name              :string
#  slug              :string
#  shortcode         :string
#  profile           :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  gender            :string
#  species           :string
#  height            :string
#  weight            :string
#  body_type         :string
#  personality       :string
#  special_notes     :text
#  featured_image_id :integer
#  profile_image_id  :integer
#  likes             :text
#  dislikes          :text
#  color_scheme_id   :integer
#

require 'rails_helper'

describe Character, type: :model do
  it 'transfers a character to registered user' do
    character = create :character
    new_user = create :user

    character.transfer_user_id = new_user.id
    character.save!

    expect(character.pending_transfer).to_not be_nil
    expect(new_user.incoming_transfers).to have(1).items

    new_user.incoming_transfers.first.accept!
    expect(character.reload.user).to eq user
  end

  it 'transfers a character to new user' do
    character = create :character

    character.transfer_user_email = 'FOO@bax.net'
    character.save!

    expect(character.pending_transfer).to_not be_nil
    expect(character.pending_transfer.invitation).to_not be_nil

    new_user = create :user, email: 'foo@bax.net'
    expect(new_user.invitation).to be_claimed
    expect(new_user.incoming_transfers).to have(1).items

    new_user.incoming_transfers.first.accept!
    expect(character.reload.user).to eq user
  end
end
