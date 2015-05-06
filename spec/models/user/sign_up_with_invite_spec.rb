require 'spec_helper'
require 'shared_contexts/user'

describe User::SignUpWithInvite do
  include_context 'user'

  context 'without an invite' do
    subject :sign_up_without_invite do
      described_class.new(user_name: invite_recipient_user_name,
                          email: Faker::Internet.safe_email,
                          password: new_password,
                          password_confirmation: new_password)
    end

    before {sign_up_without_invite.valid?}

    it {is_expected.not_to be_valid}
    it {expect(sign_up_without_invite.errors).to include(:invite)}
  end

  context 'with a spent invite' do

    let :spent_invite do
      a_user.create_invite! recipient: invite_recipient 
    end

    subject :sign_up_with_spent_invite do
      user_name = Faker::Internet.user_name
      described_class.new(user_name: user_name,
                          invite_code: spent_invite.code,
                          email: "#{user_name}@example.com",
                          password: new_password,
                          password_confirmation: new_password)
    end

    before {sign_up_with_spent_invite.valid?}

    it {is_expected.not_to be_valid}
    it {expect(sign_up_with_spent_invite.errors).to include(:code)}
  end

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
      described_class.new(user_name: invite_recipient,
                          invite_code: a_sign_up_invite.code,
                          email: a_sign_up_invite.recipient,
                          password: new_password,
                          password_confirmation: new_password)
    end

    before {sign_up_with_invite.perform!}

    it { expect(User::Account.where(id: sign_up_with_invite.account.id)).to  exist }
  end

  it 'can be created logging in with facebook' do
    # User fills up the signup form with his user name and clicks to register with facebook
    sign_up = described_class.new(invite_code: a_sign_up_invite.code,
                                  oauth_data: facebook_oauth_data)

    expect(sign_up).to be_valid
    expect(sign_up.oauth_identity).to be_a(User::Identities::Facebook)
    sign_up.perform
  end

end
