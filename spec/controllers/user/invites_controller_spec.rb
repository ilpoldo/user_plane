require 'spec_helper'
require 'shared_contexts/user'

describe User::InvitesController, type: :controller do
  include_context 'user'
  render_views

  it 'does serve an invite page' do
    session_manager = SessionManager.new(session)
    session_manager.identity = a_user.email

    get :new, use_route: 'new_user_send_sign_up_invite'
    expect(response).to have_http_status(:ok)
  end

end
