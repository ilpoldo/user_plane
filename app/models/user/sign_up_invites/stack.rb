class User::SignUpInvites::Stack < ActiveRecord::Base
  belongs_to :owner,  polymorphic: true
  has_many :invites, before_add: :decrement_remaining_invites
  after_initialize :set_remaining_invites

  # FIXME: the validation above should be enough, but doesn't seem to take effect
  # validate :remaining_invites, numericality: {greater_than_or_equal: 0}
  validate do |record|
    record.errors.add(:remaining_invites, :greater_than_or_equal, value: 0) unless (record.remaining_invites >= 0)
  end 

private

  def decrement_remaining_invites invite
    self.remaining_invites -= 1 
  end

  def set_remaining_invites
    self.remaining_invites ||= 0
  end

end
