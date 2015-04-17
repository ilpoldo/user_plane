require 'spec_helper'
require 'shared_contexts/user'

describe User::SendPasswordReset do
  include_context 'user'

  subject(:send_reset) {described_class.new(recipient: Faker::Internet.safe_email)}

  it 'is creates a password reset token'

  context 'with an invalid email address' do
    it 'does not error'
    it 'does not create a password reset token'
  end
end
