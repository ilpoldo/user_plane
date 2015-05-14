require 'spec_helper'
require 'shared_contexts/user'

describe "routest for ResetPassword" do
  include_context 'user'

  subject :reset_password do
    User::ResetPassword.new(verification: a_user.email.reset_password!)
  end

  it "routes invites" do
    path = polymorphic_path([:edit, reset_password])
    expect(get: path).to route_to("user/reset_passwords#edit", code: reset_password.code)
  end
end