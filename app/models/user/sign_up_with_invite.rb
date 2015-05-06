# set_callback :invite_set, :after, :set_email_from_invite
module User
  class SignUpWithInvite < SignUp
    attribute :invite
    attr_accessor :invite_code

    define_callbacks :invite_set

    validates :invite, receiver: {map_attributes: {created_at: :code,
                                                   base:       :code,
                                                   spent:      :code}}

    validate do |record|
      # Enforces the need of an invite if the account does not exist
      if record.account.new_record?
        record.errors.add_on_blank(:invite) if record.invite.nil?
      else
        record.errors.add(:base, :exists)
      end
    end

    def invite_code= code
      self.invite = SignUpInvites::Invite.find_by_code(code)
    end

    def invite= invite
      @invite_code = invite.code
      run_callbacks(:invite_set) {@invite = invite}
    end

    before_validation do
      @account.invite = invite
    end

  end
end