module User
  class SignIn < Imperator::Command
    include ActiveModel::Validations::Callbacks

    attribute :email
    attribute :password
    attribute :oauth_data
    attr_accessor :ominauth_error

    attribute :identity

    validate :identity, presence: {message: :invalid}
    validate :ominauth_error, absence: true


    validate do |command|
      identity = command.identity
      if identity && identity.account.suspensions
        command.errors.add(:base, :suspended)
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