module User
  class SignUpWithInvite < SignUp

    attribute :sign_up_invite
    validates :sign_up_invite, presence: true


    def invite_code= code
      self.sign_up_invite = SignUpInvites::Invite.find_by_code(code) or nil
      # TODO: set the email using the invite?
    end

    def oauth_identity= sign_up_identity
      super sign_up_identity
      self.sign_up_invite ||= self.account.invite if self.account
    end
  end
end