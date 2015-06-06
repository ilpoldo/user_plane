require 'spec_helper'
require 'shared_contexts/user'

describe "routest for ResetPassword" do
  include_context 'user'

  context 'sending' do
    subject :send_password_reset do
      User::SendPasswordReset.new(recipient: a_user.email.address)
    end

    it "routes sending password reset codes" do
      path = polymorphic_path([send_password_reset], action: :new)
      expect(get: path).to route_to("user/reset_passwords#new")
    end    
  end

  context 'redeeming' do
    
    subject :reset_password do
      User::ResetPassword.new(verification: a_user.email.reset_password!)
    end

    it "is routed" do
      path = polymorphic_path([:edit, reset_password])
      expect(get: path).to route_to("user/reset_passwords#edit", code: reset_password.code)
    end
  end


end