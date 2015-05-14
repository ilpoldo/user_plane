require 'spec_helper'
require 'shared_contexts/user'

describe "routest for Invite" do
  include_context 'user'

  subject :sign_up_with_invite do
    User::SignUpWithInvite.new(invite: a_sign_up_invite)
  end

  it "routes invites" do
    path = polymorphic_path([:edit, sign_up_with_invite])
    expect(get: path).to route_to("user/invites#edit", code: a_sign_up_invite.code)
  end

  it "routes oauth invites" do
    path = polymorphic_path([:edit, sign_up_with_invite, User::Identities::OAuthCallback.new(:facebook)])
    expect(get: path).to route_to("user/invites#oauth_callback", sign_up_with_invite_code: a_sign_up_invite.code, provider: 'facebook')
  end
end