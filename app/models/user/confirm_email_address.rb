module User
  class ConfirmEmailAddress < UserPlane::Command
    include ActiveModel::Validations::Callbacks

    attr_accessor :verification
    attr_accessor :identity
    attr_accessor :code

    validates :verification, presence: true
    # TODO: the next two validations and #code= are duplicated with the
    validates :verification, presence: true,
                             receiver: {map_attributes: {created_at: :code,
                                                         base:       :code,
                                                         spent_at:   :code}}
    validate {|r| r.errors.add(:code, 'Is not valid') unless r.verification}
    validates :identity, receiver: {map_attributes: {address: :email}}

    def to_param
      self.code
    end

    def persisted?
      verification && verification.persisted?
    end

    # FIXME: a lot of duplication with reset_password
    def code= token
      @code = token

      address_verification_query = User::Identities::EmailVerification.address_verification.where(token: code)
      if @identity = User::Identities::Email.joins(:verifications).merge(address_verification_query).first
        @verification = identity.verifications.detect {|v| v.token == code}
      end
    end

    def verification= verification
      @code = verification.token
      @verification = verification
      @identity = verification.email
    end


    before_validation do
      if verification
        identity.address = verification.recipient
        verification.spend
      end
    end

    action do
      identity.save
    end

  end
end