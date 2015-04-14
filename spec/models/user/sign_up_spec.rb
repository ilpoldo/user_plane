require 'spec_helper'
require 'shared_contexts/user'

describe User::SignUp do
  include_context 'user'

  context 'with valid details' do
    it 'succeeds' do
      p = 'some secret'
      sign_up = described_class.new(user_name: 'foo', 
                                    email: 'foo@example.com',
                                    password: p,
                                    password_confirmation: p)

      expect(sign_up).to be_valid
      sign_up.perform

      expect { User::Account.find(sign_up.account.id) }.to_not  raise_error
    end
  end
  
  context 'with bad details' do      
    it 'maps errors to the command object' do
      new_sign_up = described_class.new(user_name: a_user.name,
                                        email: a_user.email.address,
                                        password: p,
                                        password_confirmation: p)
      
      expect(new_sign_up).not_to be_valid

      expect(new_sign_up.errors[:email].size).to eq(1)
      expect(new_sign_up.errors[:user_name].size).to eq(1)
      expect(new_sign_up.errors[:email_identity].size).to eq(0)
    end
  end

  context 'with social media' do
    it 'can be invited and register with twitter'

    it 'can be created logging in with facebook' do
      # User fills up the signup form with his user name and clicks to register with facebook

      sign_up = User::SignUpWithInvite.new(invite_code: a_sign_up_invite.code,
                                           oauth_data: facebook_oauth_data)
      expect(sign_up).to be_valid
      expect(sign_up.oauth_identity).to be_a(User::Identities::Facebook)
      sign_up.perform
    end
  end

end
