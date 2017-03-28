require 'rails_helper'

feature 'Login', js: true do
  let!(:user) { create :user, email: 'jdoe@example.com', username: 'john_doe', password: 'fishsticks', password_confirmation: 'fishsticks' }

  scenario 'user successfully logs in' do
    visit login_path

    fill_in :username, with: 'john_Doe'
    fill_in :password, with: 'fishsticks'
    click_button 'Log In'

    expect(page).to have_content user.name
  end

  scenario 'user successfully logs in with email' do
    visit login_path

    fill_in :username, with: 'jdoe@EXAMPLE.com'
    fill_in :password, with: 'fishsticks'
    click_button 'Log In'

    expect(page).to have_no_content 'perm_identity'
  end
end
