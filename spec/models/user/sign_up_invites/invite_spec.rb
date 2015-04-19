require 'spec_helper'

RSpec.describe User::SignUpInvites::Invite, type: :model do
  context 'validates the recipient format' do
    subject(:invite) { described_class.new(recipient: 'not a vaild email') }

    it 'is not allowed more invites' do
      expect(invite).not_to be_valid
    end    
  end
end


