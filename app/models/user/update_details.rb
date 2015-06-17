module User
  class UpdateDetails < UserPlane::Command
    include ActiveModel::Validations::Callbacks

    # Setting the plural route key won't work, polymorphic_url will still
    # generate a path key with the singular name, so the inflector was updated
    # in this case.

    # model_name.instance_variable_set(:@singular_route_key, 'update_details')

    PasswordDetails = Struct.new(:current_password, :password, :password_confirmation) do
      def changed?
        has_passwords = password || password_confirmation
        has_passwords && (!password.empty? || !password_confirmation.empty?)
      end
    end

    attribute :account

    %w(password password_confirmation current_password).each do |attribute|
      delegate attribute.to_sym, "#{attribute}=".to_sym, to: :password_details
    end

    delegate :name, to: :account

    validates :email_identity, receiver: {map_attributes: {address:  :email,
                                                           password: :password,
                                                           password_confirmation: :password_confirmation}}
    validates :account,        receiver: {map_attributes: {name:       :user_name,
                                                           identities: :email_or_omniauth}}

    validate do |record|
      record.errors.add(:current_password, 'is not correct') if record.failed_password_change?
      if new_address = email_identity.unverified_address 
        existing_identity = User::Identities::Email.where(address: new_address).first
        record.errors.add(:email, :taken, value: new_address) if existing_identity
      end
    end

    before_validation do
      if password_details.changed? && current_password_is_valid?
        email_identity.password = password_details.password
        email_identity.password_confirmation = password_details.password_confirmation
      end
    end

    # Ensures that polymorphic_url treats this as a singular resource
    def persisted?
      true
    end


    # # Ensures that polymorphic_url treats this as a singular resource
    def to_param
      nil
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

    def email_verification
      email_identity.address_change_verification if email_identity.unverified_address_changed?
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
