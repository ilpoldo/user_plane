require 'spec_helper'

describe 'Base User API' do
  # This is more of an overview of the user API rather than rigorous unit testing

  describe 'a new user' do

    let(:a_user) do
      sign_up = Fabricate(:user_sign_up)
      sign_up.perform!
      sign_up.account
    end

    let :invite_recipient do
      Faker::Internet.user_name
    end

    let :a_sign_up_invite do
      recipient_email = "#{invite_recipient}@example.com"
      send_sign_up_invite  = User::SendSignUpInvite.new(sender: a_user,
                                                        recipient: recipient_email)
      send_sign_up_invite.perform

      invite = send_sign_up_invite.invite
    end

    it 'can be created from a registration form' do
      p = 'some secret'
      sign_up = User::SignUp.new(user_name: 'foo', 
                                 email: 'foo@example.com',
                                 password: p,
                                 password_confirmation: p)

      expect(sign_up).to be_valid
      sign_up.perform

      expect { User::Account.find(sign_up.account.id) }.to_not  raise_error
    end

    it 'can be invited by another user' do 
      p = 'some secret'
      sign_up_with_invite = User::SignUpWithInvite.new(user_name: invite_recipient,
                                                       invite_code: a_sign_up_invite.code,
                                                       email: a_sign_up_invite.recipient,
                                                       password: p,
                                                       password_confirmation: p)

      expect { sign_up_with_invite.perform! }.to_not raise_error

      expect { User::Account.find(sign_up_with_invite.account.id) }.to_not  raise_error
    end

    it 'can be invited and register with twitter'

    it 'can be created logging in with facebook' do
      # User fills up the signup form with his user name and clicks to register with facebook
        oauth_data = {provider: 'facebook',
                      uid: '1234567',
                      info: {
                        nickname: 'jbloggs',
                        email: 'joe@bloggs.com',
                        name: 'Joe Bloggs',
                        first_name: 'Joe',
                        last_name: 'Bloggs',
                        image: 'http://graph.facebook.com/1234567/picture?type=square',
                        urls: { Facebook: 'http://www.facebook.com/jbloggs' },
                        location: 'Palo Alto, California',
                        verified: true},
                      credentials: {
                        token: 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
                        expires_at: 1321747205, # when the access token expires (it always will)
                        expires: true}, # this will always be true
                      extra: {
                        raw_info: {
                          id: '1234567',
                          name: 'Joe Bloggs',
                          first_name: 'Joe',
                          last_name: 'Bloggs',
                          link: 'http://www.facebook.com/jbloggs',
                          username: 'jbloggs',
                          location: { id: '123456789', name: 'Palo Alto, California' },
                          gender: 'male',
                          email: 'joe@bloggs.com',
                          timezone: -8,
                          locale: 'en_US',
                          verified: true,
                          updated_time: '2011-11-11T06:21:03+0000'}}}

      sign_up = User::SignUpWithInvite.new(invite_code: a_sign_up_invite.code,
                                           oauth_data: oauth_data)
      expect(sign_up).to be_valid
      expect(sign_up.oauth_identity).to be_a(User::Identities::Facebook)
      sign_up.perform
    end

    it 'must have an identity' do
      sign_up = User::SignUpWithInvite.new(invite_code: a_sign_up_invite.code)
      expect(sign_up).not_to be_valid
    end

  end


  describe 'an existing user' do

    let(:a_user) do
      sign_up = Fabricate(:user_sign_up)
      sign_up.perform!
      sign_up.account
    end

    it 'can set and verify a new email address' do
      old_identity = a_user.email
      old_address = a_user.email.address
      new_address = Faker::Internet.safe_email
      
      login_token = a_user.email.serialize
      
      # TODO: wrap this into a command object to update account details
      a_user.email.new_address = new_address
      # a_user.save
      verification_token = a_user.email.email_verifications.address_verification.last.token

      login = User::Identity.deserialize!(login_token)
      expect(login).to eql(old_identity)

      expect(a_user.email.address).to eql(old_address)

      # Verifying a new address updates the login token
      a_user.email.verify_new_address! verification_token
      expect { User::Identity.deserialize!(login_token) }.to raise_error

      expect(a_user.email.address).to eql(new_address)

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
