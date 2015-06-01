module User
  class SendPasswordReset < UserPlane::Command
    attribute :email
    attr_accessor :code
    attr_accessor :identity
    attr_accessor :verification

    def email= address
      @identity = User::Identities::Email.find_by(address: address)
    end

    def persisited?
      verification ? verification.persisted? : false
    end

    action do
      if identity
        @verification ||= identity.reset_password!
        @code ||= verification.token
      end
    end
    
  end
end