require 'spec_helper'
require 'shared_contexts/user'


RSpec.feature "SignIns", type: :feature do
  include_context 'user'

  scenario 'a user signs in' do
    visit polymorphic_path([User::SignIn.new], action: :new)
    
    fill_in 'Email', with: a_user.email.address
    fill_in 'Password', with: a_user.email.password
    click_button 'Sign In'

    expect(page).to have_text 'You are successfully signed in.'
  end
end
