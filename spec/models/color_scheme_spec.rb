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
# Indexes
#
#  index_color_schemes_on_guid     (guid)
#  index_color_schemes_on_user_id  (user_id)
#

require 'rails_helper'

describe ColorScheme, type: :model do
  it_is_expected_to(
    belong_to: :user,
    have_many: :characters
  )

  it 'validates color data' do
    s = build :color_scheme
    s.set_color('some_key', 'asdfasdf')
    expect(s).to_not be_valid
    expect(s).to have(1).errors_on :someKey
  end

  it 'sets value' do
    s = ColorScheme.default
    expect { s.set_color(:primary, '#ffffff') }.to change { s.primary }.to('#ffffff')
  end

  it 'normalizes keys' do
    s = ColorScheme.default
    expect(s.text_light).to eq "rgba(255,255,255,0.3)"
  end

  it 'sets through method' do
    s = ColorScheme.default
    expect { s.primary = '#ffffff' }.to change { s.primary }.to('#ffffff')
  end

  it 'can load association' do
    s = create :color_scheme
    c = create :character, color_scheme: s
    expect { User.includes(characters: [:color_scheme]).find(c.user_id) }.to_not raise_exception
  end

  it 'does not clobber ["id"]' do
    s = create :color_scheme
    expect(s['id']).to eq s.id
  end

  it 'merges' do
    s = create :color_scheme
    s.merge(test_color: '#00FF00')
    expect(s).to be_valid
    s.save!
    s.reload
    expect(s[:testColor]).to eq '#00FF00'
  end
end
