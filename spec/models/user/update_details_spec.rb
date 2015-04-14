require 'spec_helper'
require 'shared_contexts/user'

describe User::UpdateDetails do
  include_context 'user'

  context 'when changing the email address' do
    it 'should not if the new email is already taken'
  end

  context 'after changing the email address' do

    let     (:new_address) { Faker::Internet.safe_email }
    let!    (:old_address) { a_user.email.address }
    let!    (:old_login_token) {a_user.email.serialize}

    subject (:update_details) {described_class.new(account: a_user, email: new_address)}

    before do
      update_details.perform!
      a_user.reload
    end

    it 'update the address once verified' do
      User::Identities::Email.verify_new_address! update_details.email_verification_token
      expect(a_user.email.address).to eql(new_address)
    end

    it 'does not take effect until verified' do
      expect(a_user.email.address).to eql(old_address)      
    end

    context 'the old login token' do

      it 'expires when the address is confirmed' do
        User::Identities::Email.verify_new_address! update_details.email_verification_token
        expect { User::Identity.deserialize!(old_login_token) }.to raise_error
      end

      it 'is sitll valid before the change is confirmed' do
        expect { User::Identity.deserialize!(old_login_token) }.not_to raise_error
      end
    end
  end

  context 'when updating the password' do
    let     (:new_password) { 'new shiny password' }
    let!    (:current_password) { a_user.email.password }

    context 'providing the current password' do
      subject :update_details do
        described_class.new(account: a_user,
                            current_password: current_password,
                            password: new_password,
                            password_confirmation: new_password)        
      end

      it {is_expected.to be_valid}

      it 'can be used to log in' do
        update_details.perform!
        expect(a_user.email.authenticate(new_password)).not_to be false
      end
    end

    context 'providing the wrong password' do
      subject :update_details do
        described_class.new(account: a_user,
                            current_password: 'not the old password',
                            password: new_password,
                            password_confirmation: new_password)        
      end

      it {is_expected.not_to be_valid}

      it 'the new password cannot be used to log in' do
        expect {update_details.perform!}.to raise_error
        expect(a_user.email.authenticate(new_password)).to be false
      end

      it 'the old password can still be used to log in' do
        expect {update_details.perform!}.to raise_error
        expect(a_user.email.authenticate(current_password)).not_to be false
      end
    end
  end

end
