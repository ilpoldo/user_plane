module UserPlane
  class InviteMailer < UserPlane.parent_mailer.constantize
    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.invite_mailer.invite.subject
    #
    def invite invite
      @sign_up_with_invite = User::SignUpWithInvite.new(invite: invite)

      mail to: invite.recipient
    end
  end
end
