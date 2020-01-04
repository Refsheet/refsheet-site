# == Schema Information
#
# Table name: color_schemes
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer
#  color_data :text
#  guid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe ColorScheme, type: :model do
  it_is_expected_to(
    belong_to: :user,
    have_many: :characters
  )

  it 'validates color data' do
    s = build :color_scheme
    s['some_key'] = 'asdfasdf'
    expect(s).to_not be_valid
    expect(s).to have(1).errors_on :someKey
  end

  it 'sets value' do
    s = ColorScheme.default
    expect { s[:primary] = '#ffffff' }.to change { s.primary }.to('#ffffff')
  end

  it 'normalizes keys' do
    s = ColorScheme.default
    expect(s.text_light).to eq "rgba(255,255,255,0.3)"
  end

  it 'sets through method' do
    s = ColorScheme.default
    expect { s.primary = '#ffffff' }.to change { s.primary }.to('#ffffff')
  end
end
