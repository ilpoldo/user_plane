require 'spec_helper'
require 'shared_contexts/user'

describe User::SessionsController, type: :controller do
  include_context 'user'

  let :session_manager do
    double("session_manager")
  end
  before {allow(subject).to receive(:session_manager).and_return(session_manager)}

  describe "signing in" do
    it "updates the session with the correct credentials" do 
      expect(session_manager).to receive(:identity=).with(a_user.email)
      post :create, email: a_user.email.address, password: a_user.email.password
    end

    it "does not log in with bad credentials" do 
      expect(session_manager).not_to receive(:identity=).with(a_user.email)
      post :create, email: a_user.email.address, password: 'wrong password'
    end

  end

  describe "signing out" do
    it "destroys the session" do
      expect(session_manager).to receive(:sign_out)
      get :destroy
    end
  end
end
