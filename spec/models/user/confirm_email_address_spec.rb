require 'spec_helper'
require 'shared_contexts/user'

describe User::ConfirmEmailAddress do
  include_context 'user'
  let     (:new_address) { Faker::Internet.safe_email }
  let!    (:old_address) { a_user.email.address }

  context 'with a valid confirmation token' do
    let (:address_change_verification_token) do
      address_verification = a_user.email.verifications.address_change_verification.create(recipient: new_address)
      address_verification.token
    end


    subject :confirm_email_address do
      described_class.new(code: address_change_verification_token)
    end

    it {is_expected.to be_valid}

    it 'confirms the first email address' do
      expect(a_user.email).to be_verified
    end

    it 'changes the email address' do
      confirm_email_address.perform!
      a_user.reload
      expect(a_user.email.address).to eql(new_address)
    end

    context 'once performed' do
      before do
        confirm_email_address.perform!
        a_user.reload
      end

      it 'spends the verification token' do
        confirm_email_address.verification.reload
        expect(confirm_email_address.verification).to be_spent
      end
      
      context 'cannot be redeemed anymore' do        
        subject :verifying_again do
          verifying_again = described_class.new(code: address_change_verification_token)
          verifying_again.valid?
          verifying_again
        end

        it {is_expected.not_to be_valid}
        it {expect(verifying_again.errors.messages[:code].size).to eq(1)}
      end
    end
  end

  context 'without a valid verification token' do
    subject :confirmation_with_bad_token do
      email_address_confirmation = described_class.new(code: 'not a valid token')
      email_address_confirmation.valid?
      email_address_confirmation
    end

    it {is_expected.not_to be_valid}
    it {expect(confirmation_with_bad_token.errors.messages[:code].size).to eq(1)}
  end

  context 'with an expired verification' do
    let (:stale_verification_token) do
      Timecop.travel (2.weeks + 1.day).ago do
        address_verification = a_user.email.verifications.address_change_verification.create(recipient: new_address)
        address_verification.token        
      end
    end

    subject :confirmation_with_stale_token do
      email_address_confirmation = described_class.new(code: stale_verification_token)
      email_address_confirmation.valid?
      email_address_confirmation
    end

    it {is_expected.not_to be_valid}
    it {expect(confirmation_with_stale_token.errors.messages[:code].size).to eq(1)}
  end

  context 'when the address being verified is taken' do
    let (:address_change_verification_token) do
      address_verification = a_user.email.verifications.address_change_verification.create(recipient: new_address)
      address_verification.token
    end

    subject :confirm_email_address do
      conflicting_signup = Fabricate(:user_sign_up, email: new_address)
      conflicting_signup.perform!

      described_class.new(code: address_change_verification_token)
    end

    it {is_expected.not_to be_valid}
  end

end
