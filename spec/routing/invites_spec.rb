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
    expect(url_for([:edit, sign_up_with_invite])).
      to route_to("user_plane/sign_up#edit")
  end
end