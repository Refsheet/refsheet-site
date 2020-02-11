# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  name                  :string
#  username              :string
#  email                 :string
#  password_digest       :string
#  profile               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  avatar_file_name      :string
#  avatar_content_type   :string
#  avatar_file_size      :bigint
#  avatar_updated_at     :datetime
#  settings              :json
#  type                  :string
#  auth_code_digest      :string
#  parent_user_id        :integer
#  unconfirmed_email     :string
#  email_confirmed_at    :datetime
#  deleted_at            :datetime
#  avatar_processing     :boolean
#  support_pledge_amount :integer          default(0)
#  guid                  :string
#
# Indexes
#
#  index_users_on_deleted_at      (deleted_at)
#  index_users_on_guid            (guid)
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
    respond_to: [
      :settings
    ]
  )

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

  it 'admin?' do
    u = create :admin
    expect(u).to be_admin
  end

  describe Users::EmailPrefsDecorator do
    let(:user) { create :user }

    it 'blocks all emails' do
      expect(user.email_allowed? :notification_new_message).to eq true
      user.block_all_email!
      expect(user.email_allowed? :notification_new_message).to eq false
    end

    it 'blocks some emails' do
      expect(user.email_allowed? :notification_new_message).to eq true
      user.block_email! :notification_new_message
      expect(user.email_allowed? :notification_new_message).to eq false
      expect(user.email_allowed? :notification_new_comment).to eq true
    end

    it 'whitelists some emails' do
      user.block_email! :notification_new_message
      expect(user.email_allowed? :notification_new_message).to eq false
      user.allow_email! :notification_new_message
      expect(user.email_allowed? :notification_new_message).to eq true
    end
  end

  describe '#get_settings' do
    let(:user) { create :user }
    subject { user.get_settings }

    it { is_expected.to have_key :view }

    it 'returns default settings' do
      puts subject.inspect
      view = subject[:view]

      expect(view[:nsfw_ok]).to eq false
    end

    describe '#view' do
      subject { user.get_settings[:view] }

      it { is_expected.to have_key :nsfw_ok }
      it { is_expected.to have_key :locale }
      it { is_expected.to have_key :time_zone }
    end
  end

  describe '#destroy' do
    let(:user) { create :admin, :confirmed }
    let!(:character) { create :character, user: user }
    let!(:image) { create :image, character: character }

    subject { user.destroy }

    it 'destroys images' do
      image_id = image.id
      subject
      expect(Image.find_by id: image_id).to be_nil
      expect(Image.with_deleted.find_by id: image_id).to eq image
    end

    it 'destroys characters' do
      character_id = character.id
      subject
      expect(Character.find_by id: character_id).to be_nil
      expect(Character.with_deleted.find_by id: character_id).to eq character
    end

    it 'necros this thread' do
      user_id = user.id
      subject
      expect(User.find_by id: user_id).to be_nil
      expect(User.with_deleted.find_by id: user_id).to eq user
    end
  end
end
