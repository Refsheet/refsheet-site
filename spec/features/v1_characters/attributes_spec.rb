require 'rails_helper'

feature 'Characters / Attributes', js: true do
  let(:character) { create :character, custom_attributes: [{id: 'gender', name: 'Gender', value: 'Agender'}] }

  before(:each) do
    sign_in character.user
    visit character_profile_path character.user, character
    expect(page).to have_content character.name
  end

  it 'shows custom attribute' do
    expect(page).to have_content 'Gender'
    expect(page).to have_content 'Agender'
  end

  it 'permits edit' do
    within "[data-attribute-id='gender']" do
      expect(page).to have_link 'edit'
      click_link 'edit'
    end

    within "[data-attribute-id='gender']" do
      expect(page).to have_no_content 'delete'
      fill_in 'value', with: 'Nonbinary'
      click_link 'save'
    end

    within "[data-attribute-id='gender']" do
      expect(page).to have_link 'delete'
    end

    expect(character.reload.custom_attributes[0][:value]).to eq 'Nonbinary'
  end

  it 'deletes' do
    within "[data-attribute-id='gender']" do
      click_link 'delete'
    end

    expect(page).to have_no_content 'Gender'
    expect(page).to have_no_content 'Agender'

    expect(character.reload.custom_attributes[0]).to be_nil
  end

  it 'adds' do
    within ".char-custom-attrs" do
      click_link 'add'
      fill_in 'name', with: 'Favorite Color'
      fill_in 'value', with: 'Blurple'
      click_link 'save'

      expect(page).to have_css '[data-attribute-id]', count: 2
    end

    expect(character.reload.custom_attributes[1][:value]).to eq 'Blurple'
    expect(character.custom_attributes[1][:name]).to eq 'Favorite Color'

    within "[data-attribute-id='#{character.custom_attributes[1][:id]}']" do
      expect(page).to have_content 'Favorite Color'
      expect(page).to have_content 'Blurple'
    end
  end
end
