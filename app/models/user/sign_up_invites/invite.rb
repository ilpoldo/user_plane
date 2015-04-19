module User::SignUpInvites
  class Invite < ActiveRecord::Base
    include TokenSegment

    belongs_to      :stack
    belongs_to      :sender, class_name: 'User::Account'
    has_token       :code

    validates :recipient, email: true

  end
end