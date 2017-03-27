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
#  nsfw              :boolean
#  hidden            :boolean
#  secret            :boolean
#

require 'rails_helper'

describe Character, type: :model do
  it 'transfers a character to registered user' do
    old_user = create :user
    new_user = create :user
    character = create :character, user: old_user

    character.transfer_to_user = new_user.username
    character.save!

    expect(character.pending_transfer).to_not be_nil
    expect(old_user.transfers_out.pending).to have(1).items
    expect(new_user.transfers_in.pending).to have(1).items

    new_user.transfers_in.first.claim!
    expect(character.reload.user).to eq new_user
  end

  it 'transfers a character to new user' do
    character = create :character

    character.transfer_to_user = 'FOO@bax.net'
    character.save!

    expect(character.pending_transfer).to_not be_nil
    expect(character.pending_transfer.invitation).to_not be_nil

    new_user = create :user, email: 'foo@bax.net'
    expect(new_user.invitation).to be_claimed
    expect(new_user.transfers_in.pending).to have(1).items

    new_user.transfers_in.pending.first.claim!
    expect(character.reload.user).to eq new_user
  end
end
