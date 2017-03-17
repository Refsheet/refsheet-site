# == Schema Information
#
# Table name: changelogs
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  changed_character_id :integer
#  changed_user_id      :integer
#  changed_image_id     :integer
#  changed_swatch_id    :integer
#  reason               :text
#  changes              :json
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

describe Changelog, type: :model do
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :changed_character }
  it { is_expected.to belong_to :changed_image }
  it { is_expected.to belong_to :changed_user }
  it { is_expected.to belong_to :changed_swatch }

  it 'rehydrates' do
    admin = create :admin
    user = create :user, username: 'john'

    user.update_attributes username: 'joe'
    change = Changelog.create user: admin, changed_user: user, change_data: user.previous_changes

    expect(user.username).to eq 'joe'
    expect(change.change_data).to be_a Hash
    expect(change.changed_user).to eq user
    expect(change.old_character).to be_nil
    expect(change.old_user).to_not be_nil
    expect(change.old_user.username).to eq 'john'
    expect(change.old_user).to be_changed

    change.rollback!
    user.reload

    expect(user.username).to eq 'john'
  end
end
