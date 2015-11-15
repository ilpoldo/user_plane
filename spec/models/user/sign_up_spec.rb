require 'spec_helper'
require 'shared_contexts/user'

describe User::SignUp do
  include_context 'user'

  context 'with valid details' do
    subject :sign_up do
      p = 'some secret'
      sign_up = described_class.new(user_name: 'foo', 
                                    email: 'foo@example.com',
                                    password: p,
                                    password_confirmation: p)
      sign_up.sign_up_with(User::Identities::Email)
    end

    it {is_expected.to be_valid}

    context 'succeeds' do
      before {sign_up.perform!}

      it {expect { User::Account.find(sign_up.account.id) }.to_not raise_error}
    end
  end
  
  context 'with bad details' do   
    subject :new_sign_up do
      sign_up = described_class.new(user_name: a_user.name,
                                    email: a_user.email.address,
                                    password: p,
                                    password_confirmation: p)
      sign_up.sign_up_with(User::Identities::Email)
    end

    before {new_sign_up.valid?}
      
    it {is_expected.not_to be_valid}
    it {expect(new_sign_up.errors).to include(:email)}
    it {expect(new_sign_up.errors).not_to include(:email_identity)}
  end

  context 'with social media' do
    it 'can be invited and register with twitter'

    context 'can be created logging in with facebook' do
      # User fills up the signup form with his user name and clicks to register with facebook
      subject :sign_up do
        sign_up = described_class.new(user_name: Faker::Internet.user_name,
                                      oauth_data: facebook_oauth_data)
        sign_up.sign_up_with(User::Identities::OAuth)
      end

      it {is_expected.to be_valid}      
      it {expect(sign_up.identity).to be_a(User::Identities::Facebook)}
    end
  end

end
