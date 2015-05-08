require 'spec_helper'
require 'shared_contexts/user'

describe "routest for Invite" do
  # TODO: move this somewhere sensible
  include   Rails.application.routes.url_helpers

  include_context 'user'

  subject :sign_up_with_invite do
    User::SignUpWithInvite.new(invite: a_sign_up_invite)
  end

  it "routes invites" do
    path = polymorphic_path([:edit, sign_up_with_invite])
    expect(get: path).to route_to("user/sign_up_with_invites#edit", code: a_sign_up_invite.code)
  end
end