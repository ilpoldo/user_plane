module User
  class SignUp < Imperator::Command
    include ActiveModel::Validations::Callbacks

    attribute :user_name
    
    attribute :email
    attribute :password
    attribute :password_confirmation
    
    attribute :account
    attribute :identity

    attribute :oauth_data

    # Validate command receivers
    validates :identity, receiver: {map_attributes: {address:  :email,
                                                     password: :password,
                                                     password_confirmation: :password_confirmation,
                                                     uid: :account}}
    validates :account,        receiver: {map_attributes: {name:       :user_name,
                                                           identities: :email_or_omniauth}}

    def sign_up_with sign_up_strategy
      @identity = sign_up_strategy.build_identity(self) if identity.nil?
      self
    end

    def account
      @account ||= new_account
    end

    action do
      ActiveRecord::Base.transaction do
        raise ActiveRecord::Rollback unless account.save
      end
    end

  private

    def new_account
      Account.new(name: user_name)
    end

  end

end
