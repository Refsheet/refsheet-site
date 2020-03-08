# == Schema Information
#
# Table name: api_keys
#
#  id            :bigint           not null, primary key
#  user_id       :bigint
#  guid          :string
#  secret_digest :string
#  read_only     :boolean          default(FALSE)
#  name          :string
#  deleted_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_api_keys_on_guid     (guid)
#  index_api_keys_on_user_id  (user_id)
#

require 'rails_helper'

describe ApiKey do
  it_is_expected_to respond_to: [:name, :deleted_at, :secret]

  let(:user) { create :admin }

  it 'generates secret' do
    key = ApiKey.create(user: user)
    expect(key).to be_valid
    expect(key.secret).to_not be_nil
    reloaded = ApiKey.find(key.id)
    expect(reloaded.secret).to be_nil
  end

  it 'authenticates' do
    key = ApiKey.create(user: user)
    guid, secret = [key.guid, key.secret]

    auth = ApiKey.find_by!(guid: guid)
    expect(auth.authenticate_secret(secret)).to be_truthy
  end

  it 'does not authenticate' do
    key = ApiKey.create(user: user)
    guid, secret = [key.guid, key.secret]

    auth = ApiKey.find_by!(guid: guid)
    expect(auth.authenticate_secret('poptarts')).to be_falsey
  end
end
