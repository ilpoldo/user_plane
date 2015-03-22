
module User
  class SignUp < Imperator::Command
    include ActiveModel::Validations::Callbacks

    attribute :user_name
    
    attribute :email
    attribute :password
    attribute :password_confirmation

    attribute :omniauth_data
    
    attribute :account
    attribute :email_identity
    attribute :oauth_identity

    # Validate command receivers
    validates :email_identity, receiver: {map_attributes: {address:  :email,
                                                           password: :password,
                                                           password_confirmation: :password_confirmation}}
    validates :account,        receiver: {map_attributes: {name:    :user_name}}

    validates :oauth_identity, receiver: {map_attributes: {uid: :account}}

    # Considerations for the email validation procedure
    # * should be easy to change email for admin / app
    # * creating an email verification should trigger an email message
    # * email verification should be optional, based on App configuration
    # * email uniqueness should be checked when the verification is written

    before_validation do
      self.account          =  Account.new(name: user_name)

      if email
        self.email_identity   =  account.build_email(address: email,
                                                     password: password,
                                                     password_confirmation: password_confirmation)
      end
      if omniauth_data
        self.oauth_identity = account.oauth_identities.build_from_omniauth(omniauth_data)
      end
    end

    action do
      ActiveRecord::Base.transaction do
        raise ActiveRecord::Rollback unless account.save
      end
    end

  end

end
