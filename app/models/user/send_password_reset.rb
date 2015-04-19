module User
  class SendPasswordReset < Imperator::Command
    attribute :recipient
    attr_accessor :code
    attr_accessor :identity

    def recipient= address
      @identity = User::Identities::Email.find_by(address: address)
    end

    action do
      if identity
        password_reset = identity.reset_password!
        @code ||= password_reset.token
      end
    end
    
  end
end