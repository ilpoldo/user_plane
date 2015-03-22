require 'spec_helper'

describe User::Identity do
  describe 'additional identities' do

    let(:account) {Fabricate :user}

    it 'add email' do
      p = 'long secret'
      account.email = User::Identities::Email.new(address: 'foo@example.com',
                                                  password: p,
                                                  password_confirmation: p)

    end
  end
end
