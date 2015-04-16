# TODO: rename the class EmailVerification
module User::Identities
  class EmailVerification < ActiveRecord::Base
    include TokenSegment

    self.inheritance_column = nil

    belongs_to      :email

    has_token :token, expires_in: 2.weeks, regenerate_on: :create do
      "#{Time.now}-#{rand}-#{recipient}"
    end

    validates_with UserPlane::FreshValidator, if: :spent_at_changed?
    validates_each :spent_at, if: :spent_at_changed? do |record, attr, value|
      record.errors.add(:spent_at, 'has already been spent') unless record.spent_at_was.nil?
    end

    def self.unspent
      where(spent_at: nil)
    end

    def self.spent
      where.not(spent_at: nil)
    end

    def self.address_verification
      where(type: ['SignUpAddressVerification', 'AddressChangeVerification'])
    end

    def self.address_signup_verification
      where(type: 'SignUpAddressVerification')
    end
    def self.address_change_verification
      where(type: 'AddressChangeVerification')
    end

    def self.password_reset
      where(type: 'PasswordReset')
    end

    def spend
      self.spent_at = Time.now
    end

    def spend!
      spend
      save!
    end

    def unspent?
      spent_at.nil? ? true : false
    end

    def spent?
      !unspent?
    end

  end
end