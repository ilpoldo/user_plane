require 'spec_helper'
require 'shared_contexts/user'

describe User::SignUpWithInvite do
  include_context 'user'

  context 'with an invite' do
    subject :sign_up_with_invite do
      described_class.new(user_name: invite_recipient,
                          invite_code: a_sign_up_invite.code,
                          email: a_sign_up_invite.recipient,
                          password: new_password,
                          password_confirmation: new_password)
    end

    it {expect { sign_up_with_invite.perform! }.to_not raise_error}

  end

  context 'when redeemed' do
    subject :sign_up_with_invite do
      sign_up_with_invite = described_class.new(user_name: invite_recipient,
                                                invite_code: a_sign_up_invite.code,
                                                email: a_sign_up_invite.recipient,
                                                password: new_password,
                                                password_confirmation: new_password)
      sign_up_with_invite.perform!

      sign_up_with_invite
    end

    it { expect(User::Account.where(id: sign_up_with_invite.account.id)).to  exist }
  end

end
