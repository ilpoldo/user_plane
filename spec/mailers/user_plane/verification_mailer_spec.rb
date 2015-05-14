require "spec_helper"
require 'shared_contexts/user'


module UserPlane
  describe VerificationMailer, type: :mailer do
    include_context 'user'

    describe "address_verification" do

      let :address_verification do
        a_user.email.unverified_address = Faker::Internet.safe_email
        a_user.email.save!
        User::ConfirmEmailAddress.new(verification: a_user.email.address_change_verification)
      end 

      subject(:mail) { VerificationMailer.address_verification address_verification}

      it "renders the headers" do
        expect(mail.subject).to eq("Address verification")
        expect(mail.to).to eq([address_verification.verification.recipient])
        expect(mail.from).to eq(["accounts@example.com"])
      end

      it "renders the body" do
        confirm_link = "http://example.com/account/confirm_email/#{address_verification.code}"
        expect(mail.body.encoded).to match(confirm_link)
      end
    end

    describe "password_reset" do

      let :reset_password do
        User::ResetPassword.new(verification: a_user.email.reset_password!)
      end

      subject(:mail) { VerificationMailer.password_reset reset_password}

      it "renders the headers" do
        expect(mail.subject).to eq("Password reset")
        expect(mail.to).to eq([reset_password.verification.recipient])
        expect(mail.from).to eq(["accounts@example.com"])
      end

      it "renders the body" do
        reset_link = "http://example.com/account/reset_passwords/#{reset_password.code}/edit"
        expect(mail.body.encoded).to match(reset_link)
      end
    end

  end
end
