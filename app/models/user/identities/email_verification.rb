# TODO: rename the class EmailVerification
class User::Identities::EmailVerification < ActiveRecord::Base
  self.inheritance_column = :no_column
  include TokenSegment

  belongs_to      :email

  has_token :token do
    "#{Time.now}-#{rand}-#{email.id}"
  end

  #TODO: make sure that these scopes end up working as an outer join when looking for valid email identities
  def self.unspent
    where(spent_at: nil)
  end

  def self.verification
    where(type: 'AddressVerification')
  end

  def self.password_reset
    where(type: 'PasswordReset') & where(arel_table[:created_at] >= 2.weeks.ago)
  end

  def self.stale
    where(type: 'PasswordReset') & where(arel_table[:created_at] < 2.weeks.ago)
  end

  def spend!
    performed_at = Time.now
    save!
  end

end
