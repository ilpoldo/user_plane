module User
  class SignUpWithInvite < SignUp

    attr_accessor :code
    attribute :sign_up_invite
    validates :sign_up_invite, presence: true,
                               receiver: {map_attributes: {created_at: :code,
                                                           base:       :code,
                                                           spent_at:   :code}}


    def code= code
      @code = code
      @sign_up_invite = SignUpInvites::Invite.find_by_code(code) or nil
      # TODO: set the email using the invite?
    end

    def sign_up_invite invite
      @sign_up_invite = invite
      @code = invite.code
    end

    def oauth_identity= sign_up_identity
      super sign_up_identity
      self.sign_up_invite ||= self.account.invite if self.account
    end
  end
end