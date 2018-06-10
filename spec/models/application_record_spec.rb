require 'rails_helper'

describe ApplicationRecord do
  it 'filters nulls' do
    u = build :user, profile: "I'm a \00 char, \u0000 you!"
    expect { u.save }.to_not raise_error
    expect(u.profile).to eq "I'm a  char,  you!"
  end
end
