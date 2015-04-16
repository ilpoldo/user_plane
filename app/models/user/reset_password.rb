module User
  class ResetPassword < Imperator::Command
    include ActiveModel::Validations::Callbacks

    attribute :password
    attribute :password_confirmation

    attr_accessor :verification
    attr_accessor :identity

    validates :verification, presence: true
    validates :verification, receiver: {map_attributes: {created_at: :verification,
                                                         base:       :verification,
                                                         spent_at:   :verification}}

    def verification= token
      @verification = Identities::EmailVerification.password_reset.find_by(token: token)
    end

    before_validation do
      if verification
        @identity = verification.email
        identity.attributes = {password: password,
                               password_confirmation: password_confirmation}
        verification.spend
      end
    end

    action do
      ActiveRecord::Base.transaction do
        verification.save!
        identity.save!
      end
    end
  end
end