require 'spec_helper'
require 'shared_contexts/user'


RSpec.feature "Invites", type: :feature do
  include_context 'user'

  let (:a_signup_with_invite) {User::SignUpWithInvite.new(invite: a_sign_up_invite)}

  scenario 'a user signs up' do
    visit polymorphic_path([a_signup_with_invite], action: :edit)
    
    fill_in 'User name', with: invite_recipient
    
    password = Faker::Internet.password
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password

    click_button 'Sign Up'

    expect(page).to have_text 'Welcome, you are successfully signed up.'
  end

  scenario 'a user signs up with oauth' do
    OmniAuth.config.mock_auth[:facebook] = facebook_oauth_data
    visit polymorphic_path([a_signup_with_invite], action: :edit)
    fill_in 'User name', with: invite_recipient
    click_link 'Sign Up with Facebook'
    expect(page).to have_text 'Welcome, you are successfully signed up.'
  end
end
