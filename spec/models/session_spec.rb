require 'spec_helper'

describe Session do
  describe 'logging in' do
    let(:account) { Fabricate(:user_with_email_identity) }
    let(:session) { Session.new({}) }

    it 'stores and retrieves a user account through an identity' do
      session.identity = account.identities.first
      session_hash = session.instance_variable_get '@session'
      new_session = Session.new(session_hash)
      new_session.identity.should eql(account.identities.first)
      new_session.user.should eql(account)
    end


    it 'goes stale after a few minutes' do
      session_hash = session.instance_variable_get '@session'
      new_session = Session.new(session_hash)

      Timecop.travel(90.minutes.from_now) do
        expect(new_session.identity).to be_nil
        expect(new_session.user).to be_a(User::Guest)
      end
    end

  end
end
