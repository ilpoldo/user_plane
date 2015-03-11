class User::SignUpInvites::Stack < ActiveRecord::Base
  belongs_to :account,  class_name: 'User::Account'
  has_many :invites

end
