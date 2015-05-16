require "spec_helper"
require 'shared_contexts/user'


module UserPlane
  describe InviteMailer, type: :mailer do
    include_context 'user'

    describe "invite" do

      subject(:mail) { InviteMailer.invite a_sign_up_invite }

      it "renders the headers" do
        expect(mail.subject).to eq("Invite")
        expect(mail.to).to eq([a_sign_up_invite.recipient])
        expect(mail.from).to eq(["accounts@example.com"])
      end

      it "links to the sign up page" do
        expect(mail.body.encoded).to match("http://example.com/invites/#{a_sign_up_invite.code}/redeem")
      end
    end

  end
end
