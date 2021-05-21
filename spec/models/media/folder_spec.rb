require 'rails_helper'

describe Media::Folder, type: :model do
  it_is_expected_to belong_to: [:parent,
                                :featured_media,
                                :user,
                                :character],
                    have_many: [:media,
                                :children],
                    respond_to: [:password_protected?,
                                 :authenticate!]

  describe "passwords" do
    it 'recurses to parent' do
      f0 = create :media_folder, password: 'fish'
      f1 = create :media_folder, password: nil, parent: f0
      expect(f1).to be_password_protected
      expect(f1.authenticate!('fish')).to eq true
    end

    it 'uses local over parent' do
      f0 = create :media_folder, password: 'fish'
      f1 = create :media_folder, password: 'sticks', parent: f0
      expect(f1).to be_password_protected
      expect(f1.authenticate!('fish')).to eq false
      expect(f1.authenticate!('sticks')).to eq true
    end

    it 'busts recursion' do
      f0 = create :media_folder, password: nil
      f1 = create :media_folder, password: nil, parent: f0
      f0.parent = f1
      f0.save

      expect(f1).to_not be_password_protected
    end
  end
end
