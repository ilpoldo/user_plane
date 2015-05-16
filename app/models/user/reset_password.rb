module User
  class ResetPassword < UserPlane::Command
    include ActiveModel::Validations::Callbacks

    attribute :password
    attribute :password_confirmation

    attr_accessor :code
    attr_accessor :verification
    attr_accessor :identity

    validates :password, :password_confirmation, presence: true
    validate {|r| r.errors.add(:code, 'is not valid') unless r.verification}
    validates :verification, presence: true,
                             receiver: {map_attributes: {created_at: :code,
                                                         base:       :code,
                                                         spent_at:   :code}}
    validates :identity, receiver: {map_attributes: {password: :password,
                                                     password_confirmation: :password_confirmation}}

    def to_param
      self.code
    end

    def persisted?
      verification && verification.persisted?
    end

    def code= token
      @code = token

      password_reset_query = User::Identities::EmailVerification.password_reset.where(token: code)
      if @identity = User::Identities::Email.joins(:verifications).merge(password_reset_query).first
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
        identity.attributes = {password: password,
                               password_confirmation: password_confirmation}
        verification.spend
      end
    end

    action do
      identity.save
    end
  end
end