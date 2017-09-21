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
    s.color_data['some_key'] = 'asdfasdf'
    expect(s).to_not be_valid
    expect(s).to have(1).errors_on :some_key
  end
end
