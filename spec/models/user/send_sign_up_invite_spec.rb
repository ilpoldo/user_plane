require 'spec_helper'
require 'shared_contexts/user'

describe User::SendSignUpInvite do
  include_context 'user'

  subject(:send_invite) {described_class.new(sender: a_user, recipient: invite_recipient)}

  it 'is used to send invites' do
    send_invite.perform!
    expect(send_invite.invite).not_to be_nil
  end

  context 'validation errors' do
    before do
      allow(a_user)
    end
  end
end
