Fabricator('User::SignUp', aliases: [:user_sign_up]) do
  user_name { Faker::Internet.user_name }
  email     { |attributes| "#{attributes[:user_name].parameterize}@example.com" }

  pw = 'long secret'
  password              pw
  password_confirmation pw

  after_build {|su| su.sign_up_with User::Identities::Email}
end

Fabricator(:oauth_user_sign_up, class_name: 'User::SignUp') do
  user_name { Faker::Internet.user_name }
  oauth_data do |attributes|
    uid = Faker::Number.number(7)
    email = "#{attributes[:user_name].parameterize}@example.com"
    {provider: 'facebook',
     uid: uid,
     info: {
       nickname: attributes[:user_name],
       email: email,
       name: attributes[:user_name],
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
         id: uid,
         name: 'Joe Bloggs',
         first_name: 'Joe',
         last_name: 'Bloggs',
         link: email,
         username: 'jbloggs',
         location: { id: '123456789', name: 'Palo Alto, California' },
         gender: 'male',
         email: 'joe@bloggs.com',
         timezone: -8,
         locale: 'en_US',
         verified: true,
         updated_time: '2011-11-11T06:21:03+0000'}}}    
  end

  after_build {|su| su.sign_up_with User::Identities::OAuth}
end
