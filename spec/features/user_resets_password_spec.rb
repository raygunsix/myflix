require 'spec_helper'

feature 'User resets password' do

  scenario 'user successfully resets password' do
    alice = Fabricate(:user, password: 'old_password')

    visit sign_in_path

    click_link 'Forgot Password?'
    fill_in "Email", with: alice.email
    click_button 'Send Email'

    open_email(alice.email)
    current_email.click_link 'Reset My Password'

    page.should have_content 'Reset Your Password'
    fill_in 'New Password', with: 'new_password'
    click_button 'Reset Password'

    page.should have_content 'Sign in'
    fill_in 'Email', with: alice.email
    fill_in 'Password', with: 'new_password'
    click_button 'Sign In'

    page.should have_content "Welcome, #{alice.full_name}"
  end
end