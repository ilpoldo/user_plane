module User
  class SendSignUpInvite < UserPlane::Command
    include ActiveModel::Validations::Callbacks

    attribute :recipient
    attribute :invite
    attribute :stack
    attribute :sender

    validates :invite, receiver: {map_attributes: {recipient: :recipient}}
    validates :stack,  receiver: {map_attributes: {remaining_invites: :remaining_invites}}

    before_validation do
      # The stack can be provided directly if other models have a stack of invites
      @stack ||= sender.invites_stack
      @invite ||= stack.invites.build(recipient: recipient, sender: sender)
    end

    def persisited?
      invite ? invite.persisted? : false
    end

    action do
      invite.save
    end
  end
end