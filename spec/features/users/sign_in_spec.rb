require 'rails_helper'

feature 'Sign in', %q{
  In order to be able to interact with the system
  As user 
  I want to able to log in
} do
  let!(:user) { create(:user) }

  scenario 'Registered user logs in' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Non-registered user tries to log in' do
    visit new_user_session_path

    fill_in 'Email', with: 'not-exists@mail.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
