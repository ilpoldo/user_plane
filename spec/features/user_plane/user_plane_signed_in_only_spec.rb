require 'spec_helper'
require 'shared_contexts/user'

RSpec.feature "SignedInOnly", type: :feature do
  include_context 'user'

  scenario 'trying to access a signed-in-only' do
    visit '/signed_in_only'
    expect(current_path).to eql(polymorphic_path([User::SignIn.new], action: :new))
        
    fill_in 'Email', with: a_user.email.address
    fill_in 'Password', with: a_user.email.password
    click_button 'Sign In'

    expect(current_path).to eql('/signed_in_only')
    expect(page).to have_text 'You are successfully signed in.'
  end

  scenario 'trying to access a non-existing route when sigend in' do
    visit '/non_existing'
    expect(current_path).to eql(polymorphic_path([User::SignIn.new], action: :new))
        
    fill_in 'Email', with: a_user.email.address
    fill_in 'Password', with: a_user.email.password
    click_button 'Sign In'

    expect(current_path).to eql('/non_existing')
    expect(page.status_code).to eq(404)
  end

end
