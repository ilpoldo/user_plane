# set_callback :invite_set, :after, :set_email_from_invite
module User
  class SignUpWithInvite < SignUp
    attribute :invite
    attr_accessor :code


    define_callbacks :invite_set

    validates :invite, receiver: {map_attributes: {created_at: :invite,
                                                   base:       :invite,
                                                   spent:      :invite}}

    validate do |command|
      # Enforces the need of an invite if the account does not exist
      if command.account.new_record?
        command.errors.add_on_blank(:invite) if command.invite.nil?
      else
        command.errors.add(:base, :exists)
      end
    end

    def to_param
      self.code
    end

    def persisted?
      invite && invite.persisted?
    end

    def code= code
      self.invite = SignUpInvites::Invite.find_by_code(code)
    end

    def invite= invite
      @code = invite.code
      run_callbacks(:invite_set) {@invite = invite}
    end

    before_validation do
      account.invite = invite
    end

  end
end