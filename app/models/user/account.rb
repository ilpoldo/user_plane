module User

  class Account < ActiveRecord::Base

    has_many   :oauth_identities, class_name: 'User::Identities::OAuth'
    has_one    :email,            class_name: 'User::Identities::Email'
    has_many   :suspensions,      class_name: 'User::Suspension'    

    validates :name, uniqueness: true, presence: true

    has_one    :invites_stack, class_name: 'User::SignUpInvites::Stack',
                               autosave: true
    has_one    :invite,        class_name: 'User::SignUpInvites::Invite'

    before_create :build_invites_stack

    def identities
      oauth_identities.to_a << email
    end
  end

end
