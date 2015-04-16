require 'spec_helper'
require 'shared_contexts/user'

describe User::Account do
  include_context 'user'

  it 'must have an identity' do
    new_user = described_class.new(name: Faker::Internet.user_name)
    expect(new_user).not_to be_valid
  end

  describe 'an existing user' do

    it 'can forget an identity'

    it 'can be disabled' do
      login_token = a_user.email.serialize

      a_user.suspensions.create(message: "Dodgy account")

      expect { User::Identity.deserialize!(login_token) }.to raise_error
    end

    it 'can be an admin, guest, helpdesk or editor'

  end

  describe 'user type changes' do
    
    it 'is recorded'

  end

end
