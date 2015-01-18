module User

  class Account < ActiveRecord::Base

    has_many   :oauth_identities, class_name: 'User::Identities::OAuth'
    has_one    :email,            class_name: 'User::Identities::Email'
    has_many   :suspensions,      class_name: 'User::Suspension'
    has_one    :invites_stack,    class_name: 'User::SignUpInvites::Stack'
    belongs_to :invite,           class_name: 'User::SignUpInvites::Invite'

    validates :name, uniqueness: true, presence: true


    def identities
      oauth_identities.to_a << email
    end
  end

end
