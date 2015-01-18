module User::SignUpInvites
  class Invite < ActiveRecord::Base
    include TokenSegment

    belongs_to      :stack
    has_token       :code
  end
end