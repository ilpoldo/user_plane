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

    def oauth_data= oauth_data
      @oauth_data = oauth_data
      @oauth_identity = Identities::OAuth.find_or_initialize_from_omniauth(oauth_data)
    end

    before_validation do
      @account = account_from_oauth || new_account
      if email
        @email_identity = @account.build_email(address: email,
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

    def account_from_oauth
      find_or_build_account_with_oatuh(@oauth_identity) if @oauth_identity
    end

    def new_account
      Account.new(name: user_name)
    end

  end

end
