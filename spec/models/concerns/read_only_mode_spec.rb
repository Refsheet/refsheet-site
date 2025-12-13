require 'rails_helper'

describe ReadOnlyMode, type: :model do
  let(:user) { create(:user) }
  let(:character) { create(:character, user: user) }

  describe 'when RAILS_READ_ONLY is true' do
    around do |example|
      original_value = ENV['RAILS_READ_ONLY']
      ENV['RAILS_READ_ONLY'] = 'true'
      example.run
      ENV['RAILS_READ_ONLY'] = original_value
    end

    it 'prevents saving Character' do
      character.name = 'New Name'
      expect { character.save! }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end

    it 'prevents destroying Character' do
      expect { character.destroy! }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end

    it 'prevents creating new Character' do
      new_char = Character.new(name: 'Test', user: user)
      expect { new_char.save! }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end

    it 'prevents saving User' do
      user.name = 'New Name'
      expect { user.save! }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end

    it 'prevents saving Image' do
      image = create(:image, character: character)
      image.caption = 'New Caption'
      expect { image.save! }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end
  end

  describe 'when RAILS_READ_ONLY is not set' do
    around do |example|
      original_value = ENV['RAILS_READ_ONLY']
      ENV['RAILS_READ_ONLY'] = nil
      example.run
      ENV['RAILS_READ_ONLY'] = original_value
    end

    it 'allows saving Character' do
      character.name = 'New Name'
      expect { character.save! }.not_to raise_error
    end

    it 'allows destroying Character' do
      expect { character.destroy! }.not_to raise_error
    end
  end

  describe 'when RAILS_READ_ONLY is false' do
    around do |example|
      original_value = ENV['RAILS_READ_ONLY']
      ENV['RAILS_READ_ONLY'] = 'false'
      example.run
      ENV['RAILS_READ_ONLY'] = original_value
    end

    it 'allows saving Character' do
      character.name = 'New Name'
      expect { character.save! }.not_to raise_error
    end
  end
end
