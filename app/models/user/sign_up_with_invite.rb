module User
  class SignUpWithInvite < SignUp

    attribute :sign_up_invite
    validates :sign_up_invite, presence: true


    def invite_code= code
      @sign_up_invite = SignUpInvites::Invite.find_by_code(code) or nil
    end

  end
end