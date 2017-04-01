# == Schema Information
#
# Table name: roles
#
#  id   :integer          not null, primary key
#  name :string
#

require 'rails_helper'

describe Role, type: :model do
  it_is_expected_to(
    have_many: [
      :permissions,
      :users
    ],
    validate_presence_of: :name
  )
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to allow_value('ab123_somesym').for :name }
  it { is_expected.to_not allow_value('-ab 12').for :name }
  it { is_expected.to have_many :users }

  it 'has users' do
    role = create :role, name: :admin
    user = create :user
    user.roles << role
    expect(user.role? :admin).to be_truthy
  end
end
