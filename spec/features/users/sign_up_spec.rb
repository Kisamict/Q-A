require 'rails_helper'

feature 'Sign up', %w{
  In order to create account and interact with the system
  As user 
  I want to be able to sign up 
} do
  scenario 'Unregistered user signs up' do
    visit new_user_registration_path

    fill_in 'user[email]', with: 'user@example.com'
    fill_in 'user[password]', with: '123456'
    fill_in 'user[password_confirmation]', with: '123456'

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
