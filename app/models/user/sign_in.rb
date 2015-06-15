module User
  class SignIn < UserPlane::Command
    include ActiveModel::Validations::Callbacks

    model_name.instance_variable_set(:@route_key, 'user_sign_in')

    attribute :email
    attribute :password
    attribute :oauth_data
    attribute :strategy
    attr_accessor :ominauth_error

    attribute :identity

    validates :ominauth_error, absence: true


    validate do |command|
      if identity = command.identity 
        unless identity.account.suspensions.empty?
          command.errors.add(:base, :suspended)
        end
      elsif strategy = command.strategy
        sign_in_error = :"unknown_#{strategy.model_name.singular}"
        command.errors.add(:base, sign_in_error)
      else
        raise "Please choose a strategy to perform the sign in"
      end
    end

    def sign_in_with strategy
      @strategy = strategy
      @identity = strategy.find_identity(self) if identity.nil?
      self
    end

    action do
      @identity
    end

  end
end
