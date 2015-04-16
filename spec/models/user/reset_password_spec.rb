require 'spec_helper'
require 'shared_contexts/user'

describe User::ResetPassword do
  include_context 'user'

  context 'with a valid reset token' do
    let (:reset_token) do
      password_reset_verification = a_user.email.reset_password!
      password_reset_verification.token
    end

    let! (:old_password) {a_user.email.password}

    subject :reset_password do
      described_class.new(verification: reset_token,
                          password: new_password,
                          password_confirmation: new_password)
    end

    it {is_expected.to be_valid}

    it 'resets the password' do
      reset_password.perform!
      a_user.reload
      expect(a_user.email.authenticate(new_password)).not_to be false
    end

    context 'once performed' do
      before do
        reset_password.perform!
        a_user.reload
      end

      it 'spends the verification token' do
        reset_password.verification.reload
        expect(reset_password.verification).to be_spent
      end
      
      it 'the new password can be used to authenticate' do
        expect(a_user.email.authenticate(new_password)).not_to be false
      end

      it 'a wrong password cannot be used to authenticate' do
        expect(a_user.email.authenticate('not the new password')).to be false
      end

      it 'the old password cannot be used to authenticate' do
        expect(a_user.email.authenticate(old_password)).to be false
      end

      it 'cannot be redeemed anymore' do        
        another_reset = described_class.new(verification: reset_token,
                                            password: new_password,
                                            password_confirmation: new_password)
        expect(another_reset).not_to be_valid        
        expect(another_reset.errors[:verification].size).to eq(1)
        
      end
    end
  end

  context 'without a valid reset token' do
    subject :reset_password do
      reset_password = described_class.new(verification: 'an invalid token',
                                           password: new_password,
                                           password_confirmation: new_password)
      reset_password.valid?
      reset_password
    end

    it {is_expected.not_to be_valid}
    it {expect(reset_password.errors.messages[:verification].size).to eq(1)}
  end

  context 'with an expired verification token' do
    let (:stale_verification_token) do
      Timecop.travel (2.weeks + 1.day).ago do
        address_verification = a_user.email.reset_password!
        address_verification.token        
      end
    end

    subject :reset_password_with_stale_token do
      reset_password = described_class.new(verification: stale_verification_token)
      reset_password.valid?
      reset_password
    end

    it {is_expected.not_to be_valid}
    it {expect(reset_password_with_stale_token.errors.messages[:verification].size).to eq(1)}
  end

end
