require 'spec_helper'
require 'shared_contexts/user'

describe User::SendSignUpInvite do
  include_context 'user'

  subject(:send_invite) {described_class.new(sender: a_user, recipient: invite_recipient)}

  context 'When the sender has one invite remaining' do
    before do
      a_user.invites_stack.update({remaining_invites: 1})
    end

    it 'is used to send invites' do
      send_invite.perform!
      expect(send_invite.invite).not_to be_nil
      expect(send_invite.stack.remaining_invites).to eq(0)
    end    
  end

  context 'if the user has no invites left' do
    before do
      a_user.invites_stack.update({remaining_invites: 0})
    end

    it 'is used to send invites' do
      expect(send_invite).not_to be_valid
    end
  end
end
