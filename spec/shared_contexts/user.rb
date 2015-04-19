RSpec.shared_context 'user' do

  def make_singed_up_user
    sign_up = Fabricate(:user_sign_up)
    sign_up.perform!
    sign_up.account
  end

  let(:a_user) {make_singed_up_user}

  let (:new_password) { 'new shiny password' }

  let :invite_recipient do
    Faker::Internet.safe_email
  end

  let :a_sign_up_invite do
    User::SignUpInvites::Invite.create(sender: make_singed_up_user,
                                       recipient: invite_recipient)
  end

  let :facebook_oauth_data do
    oauth_data = {provider: 'facebook',
                  uid: '1234567',
                  info: {
                    nickname: 'jbloggs',
                    email: 'joe@bloggs.com',
                    name: 'Joe Bloggs',
                    first_name: 'Joe',
                    last_name: 'Bloggs',
                    image: 'http://graph.facebook.com/1234567/picture?type=square',
                    urls: { :Facebook => 'http://www.facebook.com/jbloggs' },
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
  end
end