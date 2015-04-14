module User
  class ResetPassword < Imperator::Command
    include ActiveModel::Validations::Callbacks

    attribute :token
    attribute :password
    attribute :password_confirmation
    


    before_validation do
      verification = Identities::EmailVerification.unspent.address_verification.find_by(token: @token)
      raise ActiveRecord::RecordNotFound unless verification
      @identity = @verification.email
      @identity.attributes = {password: @password,
                              password_confirmation: @password_confirmation}
    end

    action do
      @identity.save
    end
  end
end