require 'faker'
require 'bcrypt'

Fabricator('User::Identities::Email') do
  address         { Faker::Internet.safe_email }
  password_digest { |attributes| BCrypt::Password.create(attributes[:password] || 'long password') }
end