module User
  class UpdateDetails < Imperator::Command
    include ActiveModel::Validations::Callbacks

    PasswordDetails = Struct.new(:current_password, :password, :password_confirmation) do
      def changed?
        (password || password_confirmation) ? true : false
      end
    end

    attribute :account

    delegate :password, :password=, to: :password_details
    delegate :password_confirmation, :password_confirmation=, to: :password_details
    delegate :current_password, :current_password=, to: :password_details

    validates :email_identity, receiver: {map_attributes: {address:  :email,
                                                           password: :password,
                                                           password_confirmation: :password_confirmation}}
    validates :account,        receiver: {map_attributes: {name:       :user_name,
                                                           identities: :email_or_omniauth}}

    validates_each :current_password do |record, attr, value|
      record.errors.add(attr, 'is not correct') if record.failed_password_change?
    end

    before_validation do
      if password_details.changed? && current_password_is_valid?
        email_identity.password = password_details.password
        email_identity.password_confirmation = password_details.password_confirmation
      end
    end

    action do
      @account.save
    end

    def email
      email_identity.address
    end

    def email= address
      if email_identity.new_record?
        email_identity.address = address
      else
        email_identity.unverified_address = address
      end
    end

    def email_verification_token
      email_identity.address_change_verification.token if email_identity.unverified_address_changed?
    end

    # Returns ture if a new password was set, but the change was rejected.
    def failed_password_change?
      password_details.changed? && !email_identity.password_digest_changed? ? true : false
    end

  private

    def email_identity
      @account.email || @account.build_email
    end

    def password_details
      @password_details ||= PasswordDetails.new()
    end

    def current_password_is_valid?
      unless email_identity.new_record?
        email_identity.authenticate(password_details.current_password) ? true : false
      else
        false
      end
    end

  end
end
