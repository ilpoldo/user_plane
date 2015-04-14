require 'spec_helper'
require 'shared_contexts/user'

describe User::SignUpWithInvite do
  include_context 'user'

  context 'with an invite' do
    it 'can be invited by another user' do 
      p = 'some secret'
      sign_up_with_invite = described_class.new(user_name: invite_recipient,
                                                invite_code: a_sign_up_invite.code,
                                                email: a_sign_up_invite.recipient,
                                                password: p,
                                                password_confirmation: p)

      expect { sign_up_with_invite.perform! }.to_not raise_error

      expect { User::Account.find(sign_up_with_invite.account.id) }.to_not  raise_error
    end
  end

end
