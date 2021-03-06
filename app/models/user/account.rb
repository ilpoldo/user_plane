module User

  class Account < ActiveRecord::Base

    has_many   :oauth_identities, class_name: 'User::Identities::OAuth',
                                  autosave: true
    has_one    :email,            class_name: 'User::Identities::Email',
                                  autosave: true
    has_many   :suspensions,      class_name: 'User::Suspension'

    validates :identities, presence: true

    # TODO: turn this into a configuration option?
    # in the event scenario the invites are shared across a party.    
    has_one    :invites_stack, class_name: 'User::SignUpInvites::Stack',
                               as: :owner
    has_one    :invite,        class_name: 'User::SignUpInvites::Invite'

    before_create :build_invites_stack

    def identities
      Array(email).concat(oauth_identities)
    end
  end

end
