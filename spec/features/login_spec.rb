require 'rails_helper'

feature 'Log In', js: true do
  let(:id_prefix) { "login_full" }
  let(:greeting) { "Log In" }
  let(:query) {{}}
  let(:expect_redirect) { false }
  let!(:user) { create :user, email: 'jdoe@example.com', username: 'john_doe', password: 'fishsticks', password_confirmation: 'fishsticks' }

  def try_login(valid=true, expect=nil)
    click_button 'Log In'

    if valid
      expect(page).to have_content(expect || user.username)
    else
      expect(page).to have_content(expect || 'Invalid username or password')
    end
  end

  def enter(username, password)
    fill_in id_prefix + "_user_username", with: username
    fill_in id_prefix + "_user_password", with: password
  end

  context 'using session modal' do
    let(:id_prefix) { "login_modal" }
    let(:greeting) { "Welcome back!" }

    before(:each) do
      visit "/"
      click_testid("session-nav")
      click_testid("login-modal")
      expect(page).to have_content greeting unless expect_redirect
    end

    scenario 'username missing' do
      enter nil, 'fishsticks'
      try_login false
    end

    scenario 'user successfully logs in' do
      enter 'john_Doe', 'fishsticks'
      try_login
    end
  end

  context 'using login page' do
    before(:each) do
      visit login_path query
      expect(page).to have_content 'Log In' unless expect_redirect
    end

    scenario 'username missing' do
      enter nil, 'fishsticks'
      try_login false
    end

    scenario 'password invalid' do
      enter 'john_doe', 'a;sdlkfj'
      try_login false
    end

    scenario 'username invalid' do
      enter 'johnasdf', 'fishsticks'
      try_login false
    end

    scenario 'user successfully logs in' do
      enter 'john_Doe', 'fishsticks'
      try_login
    end

    scenario 'user successfully logs in with email' do
      enter 'jdoe@EXAMPLE.com', 'fishsticks'
      try_login
    end

    context 'admin' do
      let(:query) {{ next: '/admin' }}
      let(:expect_redirect) { true }
      let!(:user) { create :admin }

      scenario 'successfully logs in' do
        enter user.username, 'fishsticks'
        try_login(true, 'Dashboard')
      end

      scenario 'rejected admin' do
        visit admin_root_path
        expect(page).to have_content 'not authorized'
        enter user.username, 'fishsticks'
        try_login(true, 'Dashboard')
      end
    end
  end

  context 'with auth code' do
    let(:token) { user.start_email_confirmation! }
    let(:query) {{ email: user.email, auth: token }}

    before(:each) do
      visit activate_path query
    end

    context 'valid' do
      scenario 'confirms email address' do
        expect(page).to have_content 'Email address confirmed'
        expect(page).to have_content user.username
        expect(user.reload).to be_confirmed
      end
    end

    context 'invalid' do
      let(:query) {{ email: user.email, auth: token + 'nacho' }}

      scenario 'fails auth confirm' do
        expect(page).to have_content 'Invalid authentication code'
        expect(page).to have_content 'Log In'
      end
    end
  end
end
