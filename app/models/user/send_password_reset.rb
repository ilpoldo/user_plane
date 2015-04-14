module User
  class SendPasswordReset < Imperator::Command
    attribute :email
    attr_reader :token

    def email= address
      @email_identity = User::Identities::Email.find_by(address: address)
    end

    action do
      password_reset = @email_identity.password_reset.create(recipient: email_identity.address)
      @token = password_reset.token
    end
    
  end
end