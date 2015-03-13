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
    

    def self.verified
      where.not(address: nil)
    end

    def address=(new_address)
      # Stores the new unverified address in as and email_verification for this identity
      email_verifications.build(type: 'AddressVerification', recipient: new_address)
    end

    def verfy_new_address!
      verification = self.email_verifications.unspent.address_verification.last
      address = verification.recipient

      ActiveRecord::Base.transaction do
        verification.spend!
        save!
      end
    end

  end

end
