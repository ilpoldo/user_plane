require 'spec_helper'

describe User::Identity do
  describe 'adding identities' do
    let(:account) {Fabricate :user}
    it 'can an email identity to the account' do
      account.email = User::Identities::Email.new(address: 'foo@example.com',
                                                  password: 'secret',
                                                  password_confirmation: 'secret')
    end
  end
end
