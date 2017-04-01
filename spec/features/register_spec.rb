require 'rails_helper'

feature 'Register', js: true do
  before(:each) do
    visit register_path
    expect(page).to have_content 'Sign Up'
  end

  def try_register(expected_error=nil)
    click_button 'Sign Up'

    if expected_error == nil
      expect(page).to have_content '@john_doe'
    else
      expect(page).to have_content expected_error
    end
  end

  def enter(values={})
    fill_in :username, with: values[:username] || 'john_doe'
    fill_in :email, with: values[:email] || 'john@example.com'
    fill_in :password, with: values[:password] || 'fishsticks'
    fill_in :password_confirmation, with: values[:password_confirmation] || 'fishsticks'

    # dob = values[:dob] || 20.years.ago
    #
    # if dob.present?
    #   select dob.day.to_s, from: :user_dob_3i
    #   select dob.strftime('%B'), from: :user_dob_2i
    #   select dob.year.to_s, from: :user_dob_1i
    # end
  end

  scenario 'successful register' do
    enter
    try_register
  end

  scenario 'invalid username' do
    enter username: 'af 324 +'
    try_register 'special characters'
  end

  scenario 'invalid email' do
    enter email: 'john.example.com'
    try_register 'must have @ sign'
  end

  scenario 'missing username' do
    enter username: ''
    try_register 'can\'t be blank'
  end

  scenario 'missing email' do
    enter email: ''
    try_register 'can\'t be blank'
  end

  scenario 'email taken' do
    create :user, email: 'john@example.com'
    enter
    try_register 'taken'
  end

  scenario 'username taken' do
    create :user, username: 'john_DOE'
    enter
    try_register 'taken'
  end

  scenario 'password mismatch' do
    enter password_confirmation: 'codpiece'
    try_register 'doesn\'t match'
  end

  scenario 'password missing' do
    enter password: '', password_confirmation: ''
    try_register 'can\'t be blank'
  end

  xcontext 'dob' do
    scenario 'missing' do
      enter dob: ''
      try_register 'can\'t be blank'
    end

    scenario 'kiddo' do
      enter dob: 12.years.ago
      try_register 'must be 18 years or older'
    end
  end
end
