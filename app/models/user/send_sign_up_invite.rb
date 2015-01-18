module User

  class SendSignUpInvite < Imperator::Command
    attribute :sender
    attribute :recipient
    attribute :invite

    action do
      invite = sender.invites_stack.invites.create_invite(recipient: recipient)
    end
    
  end
  
end