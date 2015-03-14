# TODO: rename the class EmailVerification
class User::Identities::EmailVerification < ActiveRecord::Base
  self.inheritance_column = nil
  
  include TokenSegment

  belongs_to      :email

  has_token :token, regenerate_on: :create do
    "#{Time.now}-#{rand}-#{recipient}"
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

  def self.password_reset
    where(type: 'PasswordReset')
  end

  def self.fresh
    where(arel_table[:created_at] < 2.weeks.ago)
  end

  def self.stale
    where.not(arel_table[:created_at] < 2.weeks.ago)
  end

  def spend!
    spent_at = Time.now
    save!
  end

end
