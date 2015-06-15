require 'spec_helper'
require 'shared_contexts/user'

describe User::InvitesController, type: :controller do
  include_context 'user'
  render_views

  # TODO: report this bug. You can't reproduce every route without use_route
  # because all params are stringified, but constraints can be symbols
  BackToSymbol = Struct.new(:to_s)

  it 'does serve an invite page' do
    session_manager = SessionManager.new(session)
    session_manager.identity = a_user.email

    concern = BackToSymbol.new(:signed_in)
    get :new, concern: concern
    expect(response).to have_http_status(:ok)
  end

end
