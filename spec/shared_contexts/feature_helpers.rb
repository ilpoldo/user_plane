RSpec.shared_context 'feature_helpers' do

  # TODO: find a better way to mock being signed in
  def sign_in(account)
    visit polymorphic_path([User::SignIn.new], action: :new)
    
    fill_in 'Email', with: account.email.address
    fill_in 'Password', with: account.email.password
    click_button 'Sign In'
  end

end
