
module User
  class SignUp < Imperator::Command
    include ActiveModel::Validations::Callbacks

    attribute :user_name
    attribute :email
    attribute :password
    attribute :password_confirmation
    
    attribute :account
    attribute :email_identity

    # Validate input
    validates :password,  :password_confirmation, presence: true
    validates :password,  confirmation: true,
                          length: {within: 8..56}

    # Validate command receivers
    validates :email_identity,   receiver: {map_attributes: {address: :email}}
    validates :account,          receiver: {map_attributes: {name:    :user_name}}


    # Considerations for the email validation procedure
    # * should be easy to change email for admin / app
    # * creating an email verification should trigger an email message
    # * email verification should be optional, based on App configuration
    # * email uniqueness should be checked when the verification is written

    before_validation do
      self.account          =  Account.new(name: user_name)

      self.email_identity   =  account.build_email(address: email,
                                                   password: password,
                                                   password_confirmation: password_confirmation)
    end

    action do
      ActiveRecord::Base.transaction do
        raise ActiveRecord::Rollback unless account.save
      end
    end

  end

end
