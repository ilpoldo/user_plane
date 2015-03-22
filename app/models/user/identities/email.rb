require 'bcrypt'

module User

  class Identities::Email < Identity

    has_many        :email_verifications
    belongs_to      :account,  class_name: 'User::Account'
    has_one         :id_token, as: :identity

    has_secure_password

    validates :password,  :password_confirmation, presence: true, on: :create
    validates :password,  confirmation: true,
                          length: {within: 8..56},
                          on: :create

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

    # Starts the address change process by creating a new email verification token
    def new_address=(new_address)
      email_verifications.create(type: 'AddressChangeVerification',
                                 recipient: new_address)
    end

    # Completes the verification process by redeeming an email verification token
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
