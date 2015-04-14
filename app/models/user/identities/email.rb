require 'bcrypt'

module User

  class Identities::Email < Identity

    has_many        :email_verifications
    belongs_to      :account,  class_name: 'User::Account'
    has_one         :id_token, as: :identity

    has_secure_password

    before_validation do
      self.build_id_token if (address_changed? || password_digest_changed?)
    end

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

    # Completes the verification process by redeeming an email verification token
    def self.verify_new_address! token
      verification = Identities::EmailVerification.unspent.address_verification.find_by(token: token)
      raise ActiveRecord::RecordNotFound unless verification
      verification.email.address = verification.recipient

      ActiveRecord::Base.transaction do
        verification.spend!
        verification.email.save!
      end
    end

    # Starts the address change process by creating a new email verification token
    def change_address(new_address)
      email_verifications.create(type: 'AddressChangeVerification',
                                 recipient: new_address)
    end
    alias_method :new_address=, :change_address


  end

end
