require 'rails_helper'

feature 'Password Resets', js: true do
  let!(:user) { create :user, email: 'jdoe@example.com', username: 'john_doe', password: 'fishsticks', password_confirmation: 'fishsticks' }

  before(:each) do
    visit root_path anchor: 'session-modal'
    expect(page).to have_content 'Welcome back!'
    click_link 'Forgot password?'
  end

  describe 'create password resets' do
    scenario 'valid email' do
      expect(UserMailer).to receive(:password_reset).and_call_original
      fill_in :user_email, with: user.email
      click_button 'Continue'
      expect(page).to have_content 'Please enter the 6 digit code'
    end

    scenario 'invalid email' do
      fill_in :user_email, with: 'asdfasdfasdfafds'
      click_button 'Continue'
      expect(page).to have_content 'User not found'
    end
  end

  describe 'update password resets' do
    before do
      fill_in :user_email, with: user.email
      click_button 'Continue'
      expect(page).to have_content '6 digit code'
    end

    scenario 'invalid code' do
      fill_in :reset_token, with: 'abc123'
      click_button 'Continue'
      expect(page).to have_content 'Invalid token.'
    end

    scenario 'valid code' do
      token = user.start_account_recovery!
      expect(token).to match /\A\d{6}\z/
      expect(user.check_account_recovery? token).to be_truthy
    end

    scenario "valid code but ui version" do
      token = user.start_account_recovery!
      fill_in :reset_token, with: token
      click_button 'Continue'
      expect(page).to have_content 'Enter a new password'
    end
  end

  describe 'change password' do
    before do
      fill_in :user_email, with: user.email
      click_button 'Continue'
      expect(page).to have_content '6 digit code'

      token = user.start_account_recovery!
      expect(token).to match /\A\d{6}\z/

      fill_in :reset_token, with: token
      click_button 'Continue'
      expect(page).to have_content 'Enter a new password'
    end

    scenario 'invalid password' do
      fill_in :user_password, with: 'foo'
      fill_in :user_password_confirmation, with: 'bar'
      click_button 'Change Password'
      expect(page).to have_content 'doesn\'t match'
    end

    scenario 'valid password' do
      fill_in :user_password, with: 'taco-tuesday'
      fill_in :user_password_confirmation, with: 'taco-tuesday'
      click_button 'Change Password'
      expect(page).to have_content 'Password changed'
      expect(user.reload.authenticate 'taco-tuesday').to be_truthy
      expect(user.reload.account_recovery_token).to be_nil
      expect(page).to have_no_content 'Welcome back'
    end
  end

  scenario 'direct link' do
    token = user.start_account_recovery!
    visit recovery_path email: user.email, auth: token
    expect(page).to have_content user.username
    expect(page).to have_content 'signed in'
    expect(page).to have_content 'User Settings'
  end
end
