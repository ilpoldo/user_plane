module User::SignUpInvites
  class Invite < ActiveRecord::Base
    include TokenSegment

    belongs_to      :stack
    belongs_to      :sender, class_name: 'User::Account'
    belongs_to      :account, class_name: 'User::Account'
    has_token       :code

    validates :recipient, email: true

    # Once an invite has been associated with an account it cannot be reused
    validate on: :update do |r|
      if account_id_changed?
        previous, current = account_id_change
        r.errors.add(:base, :redeemed) unless previous.nil?
      end
    end

    # Returns a Null invite
    def self.find_by_code code
      super(code) || Null(code)      
    end

  end

  # A Null invite is an invite-like object created when the invite code is not
  # valid. It will 
  Null = Struct.new(:code) do
    include ActiveModel::Validations

    validate {|r| r.errors.add(:base, :invalid) }

    def method_missing method_name
      return nil if [:stack, :sender, :recipient].include? method_name
      super 
    end
  end
end