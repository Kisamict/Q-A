require 'rails_helper'

feature 'Sign out', %q{
  In order to finish working with the system
  As user 
  I want to be able to sign out
} do
  let!(:user) { create(:user) }

  before { sign_in(user) }

  scenario 'User signs out' do
    visit questions_path
    
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
