require 'spec_helper'

describe SessionManager do
  describe 'logging in' do
    let(:account) { Fabricate(:user_with_email_identity) }
    let(:session_manager) { SessionManager.new({}) }

    it 'stores and retrieves a user account through an identity' do
      session_manager.identity = account.identities.first
      session_hash = session_manager.instance_variable_get '@session'
      new_session = SessionManager.new(session_hash)
      expect(new_session.identity).to eql(account.identities.first)
      expect(new_session.user).to eql(account)
    end


    it 'goes stale after a few minutes' do
      session_hash = session_manager.instance_variable_get '@session'
      new_session_manager = SessionManager.new(session_hash)

      Timecop.travel(90.minutes.from_now) do
        expect(new_session_manager.identity).to be_nil
        expect(new_session_manager.user).to be_a(User::Guest)
      end
    end

  end
end
