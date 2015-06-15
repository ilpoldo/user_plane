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

  scenario 'a user signs in with oauth' do
    endpoint = User::Identities::OAuthEndpoint.new(:facebook)
    OmniAuth.config.mock_auth[:facebook] = an_oauth_sign_up.oauth_data

    visit polymorphic_path([:user_sign_in, endpoint])
    expect(page).to have_text 'You are successfully signed in.'
  end

  scenario 'someone tries to sign in without password' do
    visit polymorphic_path([User::SignIn.new], action: :new)
    
    fill_in 'Email', with: a_user.email.address
    click_button 'Sign In'

    expect(page).to have_text 'Sign in failed:'
    expect(page).to have_text 'Unknown email/password combination'
  end

  scenario 'Unregistered user signs in with facebook before signing up' do
    endpoint = User::Identities::OAuthEndpoint.new(:facebook)
    OmniAuth.config.mock_auth[:facebook] = facebook_oauth_data

    visit polymorphic_path([:user_sign_in, endpoint])
    expect(page).to have_text 'Sign in failed:'
    expect(page).to have_text 'Unknown account'
  end
end
