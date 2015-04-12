
module User
  class SignUp < Imperator::Command
    include ActiveModel::Validations::Callbacks

    attribute :user_name
    
    attribute :email
    attribute :password
    attribute :password_confirmation
    
    attribute :account
    attribute :email_identity
    attribute :oauth_identity

    attribute :oauth_data

    # Validate command receivers
    validates :email_identity, receiver: {map_attributes: {address:  :email,
                                                           password: :password,
                                                           password_confirmation: :password_confirmation}}
    validates :account,        receiver: {map_attributes: {name:       :user_name,
                                                           identities: :email_or_omniauth}}

    validates :oauth_identity, receiver: {map_attributes: {uid: :account}}

    # Considerations for the email validation procedure
    # * should be easy to change email for admin / app
    # * creating an email verification should trigger an email message
    # * email verification should be optional, based on App configuration
    # * email uniqueness should be checked when the verification is written

    def oauth_data= oauth_data
      @oauth_data = oauth_data
      self.oauth_identity = Identities::OAuth.find_or_initialize_from_omniauth(oauth_data)
    end

    def oauth_identity= sign_up_identity
      @oauth_identity = sign_up_identity
      self.account = find_or_build_account_with_oatuh(sign_up_identity)
    end


    before_validation do
      self.account ||= new_account
      if email
        self.email_identity = account.build_email(address: email,
                                                  password: password,
                                                  password_confirmation: password_confirmation)
      end
    end

    action do
      ActiveRecord::Base.transaction do
        raise ActiveRecord::Rollback unless account.save
      end
    end

  private

    def find_or_build_account_with_oatuh oauth_identity
      if existing_account = oauth_identity.account
        existing_account
      else
        account = new_account
        account.oauth_identities << oauth_identity

        account
      end
    end

    def new_account
      Account.new(name: user_name)
    end

  end

end
