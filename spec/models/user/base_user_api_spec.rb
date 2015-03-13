require 'spec_helper'

describe 'Base User API' do
  # This is more of an overview of the user API rather than rigorous unit testing

  describe 'a new user' do

    let(:a_user) do
      sign_up = Fabricate(:user_sign_up)
      sign_up.perform!
      sign_up.account
    end

    it 'can be created from a registration form' do
      p = 'some secret'
      sign_up = User::SignUp.new(user_name: 'foo', 
                                 email: 'foo@example.com',
                                 password: p,
                                 password_confirmation: p)
      sign_up.should be_valid
      sign_up.perform

      expect { User::Account.find(sign_up.account.id) }.to_not  raise_error
    end

    it 'can be invited by another user' do 

      recipient       = Faker::Internet.user_name
      recipient_email = "#{recipient}@example.com"
      send_sign_up_invite  = User::SendSignUpInvite.new(sender: a_user,
                                                       recipient: recipient_email)
      send_sign_up_invite.perform

      invite = send_sign_up_invite.invite

      p = 'some secret'
      sign_up_with_invite = User::SignUpWithInvite.new(user_name: recipient,
                                                       invite_code: invite.code,
                                                       email: recipient_email,
                                                       password: p,
                                                       password_confirmation: p)

      expect { sign_up_with_invite.perform! }.to_not raise_error

      expect { User::Account.find(sign_up_with_invite.account.id) }.to_not  raise_error
    end

    it 'can be invited and register with twitter'

    it 'can be created logging in with twitter' do
      # User fills up the signup form with his user name and clicks to register with twitter
      sign_up = User::Identities::OAuth.identity(user_name: 'foo', 
                                                 provider: 'twitter')
      sign_up.should be_valid
      sign_up.perform
      # If valid (invite, unique name etc), a user with a pending identity is created
      # The pending identity identificator is stored in the user's cookies
      # The user is redirected to twiiter to authorize the app
      # If the authorization fails the user's pending identity is destroyed
      # If authorized the user is found through his pending identity and the identity is replaced with the new one.

    end

  end


  describe 'an existing user' do

    let(:a_user) do
      sign_up = Fabricate(:user_sign_up)
      sign_up.perform!
      sign_up.account
    end

    it 'can update his email address' do
      old_identity = a_user.email
      old_email = a_user.email.address
      new_email = Faker::Internet.email
      
      login_token = a_user.email.serialize
      
      a_user.email.address = new_email
      a_user.save

      login = User::Identity.deserialize!(login_token)
      expect(login).to eql(old_identity)

      expect(a_user.email.address).to eql(old_email)

      a_user.email.verify!
      login = User::Identity.deserialize!(login_token)
      expect(login).to be_nil
      expect(a_user.email.address).to eql(new_email)

    end
    it 'can cange his password providing the old one'

    it 'can reset the password using a password reset token'

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
