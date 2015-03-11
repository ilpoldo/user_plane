require 'faker'
require 'bcrypt'

Fabricator('User::Identities::Email') do
  address  { Faker::Internet.safe_email }
  password { |attributes| attributes[:password] || 'long password' }
  password_confirmation { |attributes| attributes[:password] || 'long password' }
end