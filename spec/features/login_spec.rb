require 'rails_helper'

feature 'Log In', js: true do
  let(:query) {{}}
  let(:expect_redirect) { false }
  let!(:user) { create :user, email: 'jdoe@example.com', username: 'john_doe', password: 'fishsticks', password_confirmation: 'fishsticks' }

  before(:each) do
    visit login_path query
    expect(page).to have_content 'Log In' unless expect_redirect
  end

  def try_login(valid=true)
    click_button 'Log In'

    if valid
      expect(page).to have_content user.username
    else
      expect(page).to have_content 'Invalid username or password'
    end
  end

  def enter(username, password)
    fill_in :user_username, with: username
    fill_in :user_password, with: password
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

  context 'with auth code' do
    let(:token) { user.generate_auth_code! }
    let(:query) {{ email: user.email, auth: token }}

    context 'valid' do
      let(:expect_redirect) { true }

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

  xcontext 'admin' do
    let!(:user) { create :user }
    let!(:role) { create :role, name: :admin }
    before { user.roles << role }

    scenario 'successfully logs in' do
      enter user.username, 'fishsticks'
      try_login
      expect(page).to have_content 'Dashboard'
    end

    scenario 'rejected admin' do
      visit admin_root_path
      expect(page).to have_content 'not authorized'
      enter user.username, 'fishsticks'
      try_login
      expect(page).to have_content 'Dashboard'
    end
  end
end
