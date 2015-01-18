module User
  class SignUpWithInvite < SignUp

    attribute :sign_up_invite
    validates :sign_up_invite, presence: true


    def invite_token= token
      @sign_up_invite = Invite.find_by_token(token) or nil
    end

  end
end