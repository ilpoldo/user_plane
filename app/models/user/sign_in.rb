module User
  class SignIn < UserPlane::Command
    include ActiveModel::Validations::Callbacks

    model_name.instance_variable_set(:@route_key, 'user_sign_in')

    attribute :email
    attribute :password
    attribute :oauth_data
    attr_accessor :ominauth_error

    attribute :identity

    validates :ominauth_error, absence: true


    validate do |command|
      if identity = command.identity 
        unless identity.account.suspensions.empty?
          command.errors.add(:base, :suspended)
        end
      else
        command.errors.add(:base, :invalid)
      end
    end

    def sign_in_with sign_in_strategy
      @identity = sign_in_strategy.find_identity(self) if identity.nil?
      self
    end

    action do
      @identity
    end

  end
end
