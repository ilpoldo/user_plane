require 'spec_helper'

RSpec.describe User::SignUpInvites::Stack, :type => :model do

  subject(:invites_stack) {described_class.create(remaining_invites: 2)}

  it 'decrements the available invites' do
    invites_stack.invites.create(recipient: Faker::Internet.safe_email)
    expect(invites_stack.remaining_invites).to eql(1)
  end

  context 'when the stack is out of invites' do
    subject(:dry_invites_stack) {described_class.create(remaining_invites: 0)}

    it 'is not allowed more invites' do
      new_invite = dry_invites_stack.invites.create(recipient: Faker::Internet.safe_email)
      expect(dry_invites_stack).not_to be_valid
    end    
  end

end
