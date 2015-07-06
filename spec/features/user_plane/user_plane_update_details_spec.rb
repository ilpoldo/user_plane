require 'spec_helper'
require 'shared_contexts/user'
require 'shared_contexts/feature_helpers'

RSpec.feature "UpdateDetails", type: :feature do
  include_context 'user'
  include_context 'feature_helpers'

  scenario 'changing the email address' do
    sign_in(a_user)
    
    new_email = Faker::Internet.safe_email

    visit polymorphic_path([User::UpdateDetails.new], action: :edit)
    fill_in 'Email', with: new_email
    click_button 'Update'

    click_link 'Sign Out'

    open_email(new_email)
    current_email.click_link 'link'

    
    visit polymorphic_path([User::SignIn.new], action: :new)
    fill_in 'Email', with: new_email
    fill_in 'Password', with: a_user.email.password
    click_button 'Sign In'

    expect(page).to have_text 'You are successfully signed in.'
    # expect(current_path).to eql('/signed_in_only')
  end

  scenario 'changing the user name' do
    sign_in(a_user)
    
    visit polymorphic_path([User::UpdateDetails.new], action: :edit)
    fill_in 'Name', with: 'marvin'
    click_button 'Update'

    expect(page).to have_selector('input[value="marvin"]')
  end

end
