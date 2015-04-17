module User
  class SendPasswordReset < Imperator::Command
    attribute :email
    attr_reader :token

    def email= address
      @email_identity = User::Identities::Email.find_by(address: address)
    end

    action do
      if @email_identity
        password_reset = @email_identity.reset_password!
        @token = password_reset.token
      end
    end
    
  end
end