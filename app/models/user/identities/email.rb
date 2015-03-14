require 'bcrypt'

module User

  class Identities::Email < Identity

    has_many        :email_verifications
    belongs_to      :account,  class_name: 'User::Account'
    has_one         :id_token, as: :identity

    has_secure_password

    validates_presence_of :password, on: :create


    # All the profile editing (password reset, email change) stuff should be performed
    # using some ActiveRecord form object and the user should have a state thing.
    validates :address, presence:   true,
                        uniqueness: {message: 'is taken'},
                        format:     {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}

    # TODO: move these in the relation scope?
    current_address = arel_table[:address].eq(Identities::EmailVerification.arel_table[:recipient])
    verified_address = Identities::EmailVerification.address_verification.spent.where(current_address)
    
    def self.verified
      joins(:email_verifications).where(verified_address)
    end

    def self.unverified
      joins(:email_verifications).where.not(verified_address)
    end
    
    def self.must_verify_new_identities
      false
    end

    # def self.verified
    #   joins(:email_verifications, Arel::Nodes::OuterJoin) |
    #   Identities::EmailVerification.signup_address.unspent
    # end

    # TODO: add a verified? boolean method - can you change email with an unverified account?

    def new_address=(new_address)
      email_verifications.create(type: 'AddressChangeVerification',
                                 recipient: new_address)
    end

    def verify_new_address! token
      verification = email_verifications.unspent.address_verification.where(token: token).last
      self.address = verification.recipient

      ActiveRecord::Base.transaction do
        verification.spend!
        save!
      end
    end

  end

end
