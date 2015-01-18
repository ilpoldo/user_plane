require 'bcrypt'

module User

  class Identities::Email < Identity

    has_one         :email_verification
    belongs_to      :account,  class_name: 'User::Account'
    has_one         :id_token, as: :identity

    has_secure_password

    validates_presence_of :password, on: :create


    # All the profile editing (password reset, email change) stuff should be performed
    # using some ActiveRecord form object and the user should have a state thing.
    validates :address, presence:   true,
                        uniqueness: {message: 'is taken'},
                        format:     {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
    
    
    def self.verified
      joins(:email_verification, Arel::Nodes::OuterJoin) | EmailUpdateKey.verification
    end

  end

end
