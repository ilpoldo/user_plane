
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

    before_validation do
      self.account          =  Account.new(name: user_name)

      self.email_identity   =  Identities::Email.new(address: email,
                                                     password: password,
                                                     password_confirmation: password_confirmation)
      self.account.email = self.email_identity
    end

    action do
      ActiveRecord::Base.transaction do
        raise ActiveRecord::Rollback unless account.save
      end
    end

  end

end
