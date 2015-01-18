class User::SignUpInvites::Stack < ActiveRecord::Base

  belongs_to :account
  has_many :invites

end
