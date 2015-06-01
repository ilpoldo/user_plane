require 'spec_helper'
require 'shared_contexts/user'


RSpec.feature "ResetPassword", type: :feature do
  include_context 'user'

  scenario 'a user resets the password' do
    visit polymorphic_path([User::SendPasswordReset.new], action: :new)

    fill_in 'Email', with: a_user.email.address
    click_button 'Send'

    expect(page).to have_text 'Your password reset code is being sent.'

    open_email(a_user.email.address)
    current_email.click_link 'link'
    expect(page).to have_content 'Reset Password'

    fill_in 'Password', with: 'some password'
    fill_in 'Password confirmation', with: 'some password'

    click_button 'Reset Password'
    
    expect(page).to have_text 'Your password has been reset.'

    login = User::Identities::Email.find_identity(email: a_user.email.address,
                                                  password: 'some password')
    expect(login).not_to be_nil
  end
end
