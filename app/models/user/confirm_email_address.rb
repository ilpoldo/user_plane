module User
  class ConfirmEmailAddress < Imperator::Command
    include ActiveModel::Validations::Callbacks

    attr_accessor :verification
    attr_accessor :identity

    validates :verification, presence: true
    validates :verification, receiver: {map_attributes: {created_at: :verification,
                                                         base:       :verification,
                                                         spent_at:   :verification}}

    def verification= token
      @verification = Identities::EmailVerification.address_verification.find_by(token: token)
    end

    before_validation do
      if verification
        @identity = verification.email
        identity.address = verification.recipient
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