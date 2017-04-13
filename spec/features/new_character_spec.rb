require 'rails_helper'

feature 'New Character', js: true do
  let(:user) { create :user }
  before { sign_in user }

  before(:each) do
    visit user_profile_path user
    page.find('#user-actions').click
    page.find('#action-new-character').click
    expect(page).to have_content 'New Character'
  end

  def try_create(expected_error=nil)
    click_button 'Create Character'

    if expected_error == nil
      expect(page).to have_content 'About Test Character'
    else
      expect(page).to have_content expected_error
    end
  end

  def enter(values={})
    fill_in :character_name, with: values[:name] || 'Test Character'
    fill_in :character_species, with: values[:species] || 'Bat'
    fill_in :character_slug, with: values[:slug] if values.include? :slug
    fill_in :character_shortcode, with: values[:shortcode] if values.include? :shortcode
  end

  scenario 'successful create' do
    enter
    try_create
  end

  scenario 'taken shortcode' do
    create :character, shortcode: 'fubar'
    enter shortcode: 'fubar'
    try_create 'taken'
  end

  scenario 'taken slug' do
    create :character, slug: 'fubar', user: user
    enter slug: 'fubar'
    try_create 'taken'
  end

  scenario 'taken slug by another' do
    create :character, slug: 'fubar'
    enter slug: 'fubar'
    try_create
  end
end
