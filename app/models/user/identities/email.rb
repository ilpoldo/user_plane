module User
  class Identities::Email < Identity

    has_many        :verifications, class_name: 'User::Identities::EmailVerification',
                                    autosave: true
    belongs_to      :account,  class_name: 'User::Account'
    has_one         :id_token, as: :identity
    attr_accessor   :address_change_verification

    has_secure_password

    before_validation do
      self.build_id_token if (address_changed? || password_digest_changed?)
    end

    validates :password,  length: {within: 8..56},
                          if: :password_digest_changed?

    validates :address, presence:   true,
                        uniqueness: true,
                        email:      true

    # TODO: move these in the relation scope?
    current_address = arel_table[:address].eq(Identities::EmailVerification.arel_table[:recipient])
    verified_address = Identities::EmailVerification.address_verification.spent.where(current_address)
    
    # Scope for all the email addresses that have been verified via email verifications
    # or, implicitly, via password resets.
    def self.verified
      joins(:verifications).where(verified_address)
    end

    def self.unverified
      joins(:verifications).where.not(verified_address)
    end

    def verified?
      verifications.spent.where(recipient: address) ? true : false
    end

    # Starts the address change process by creating a new email verification token
    def change_address(new_address)
      @address_change_verification ||= verifications.create(type: 'AddressChangeVerification')
      address_change_verification.recipient = new_address
    end
    alias_method :unverified_address=, :change_address

    def unverified_address
      @address_change_verification && @address_change_verification.recipient 
    end

    def unverified_address_changed?
      @address_change_verification ? true : false
    end

    # Returns a newly-created password reset token
    def reset_password!
      verifications.password_reset.create(recipient: address)
    end

    # Forces validation of the email address
    def self.verify_address! token
      verification = Identities::EmailVerification.address_verification.find_by(token: token)
      raise ActiveRecord::RecordNotFound unless verification
      verification.email.address = verification.recipient
      verification.email.save!
    end


  end
end
