require 'spec_helper'
require 'shared_contexts/user'

describe "routest for Invite" do
  include_context 'user'

  context 'redeeming' do
    subject :sign_up_with_invite do
      User::SignUpWithInvite.new(invite: a_sign_up_invite)
    end


    it "is routed" do
      path = polymorphic_path([:edit, sign_up_with_invite])
      expect(get: path).to route_to("user/invites#edit", code: a_sign_up_invite.code)
    end

    it "can be routed with the oauth callback path" do
      path = polymorphic_path([:edit, sign_up_with_invite, User::Identities::OAuthCallback.new(:facebook)])
      expect(get: path).to route_to("user/invites#oauth_callback",
                                    sign_up_with_invite_code: a_sign_up_invite.code,
                                    provider: 'facebook',
                                    on: :member)
    end
  end

  context 'creating' do
    subject :send_sign_up_invite do
      User::SendSignUpInvite.new(recipient: Faker::Internet.safe_email)
    end

    it "routes sending sign up invites" do
      path = polymorphic_path([send_sign_up_invite], action: :new)
      expect(get: path).to route_to("user/invites#new", concern: :signed_in)
    end    
  end

end