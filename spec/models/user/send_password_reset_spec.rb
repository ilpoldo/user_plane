require 'spec_helper'
require 'shared_contexts/user'

describe User::SendPasswordReset, type: :model do
  include_context 'user'

  let :dummy_verification do
    double(User::Identities::EmailVerification, save: true, token: '123456')
  end

  context 'resetting the password for an existing account' do
    subject(:send_reset) {described_class.new(recipient: a_user.email.address)}

    it 'has a verification code' do
      send_reset.perform!
      expect(send_reset.code).not_to be_nil
    end

    it 'does create an email verification' do
      expect(User::Identities::EmailVerification).to receive(:new).and_return(dummy_verification)
      send_reset.perform!
    end
  end

  context 'with an unknown email address' do
    before do
      allow(User::Identities::Email).to receive(:find_by).and_return(nil)
    end

    subject(:send_reset) {described_class.new(recipient: a_user.email.address)}

    it {is_expected.to be_valid}

    it 'has no verification code' do
      send_reset.perform!
      expect(send_reset.code).to be_nil
    end

    it 'does not create an email verification' do
      expect(User::Identities::EmailVerification).not_to receive(:new)
      send_reset.perform!
    end
  end
end
