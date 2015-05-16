require 'faker'

Fabricator('User::Account', aliases: [:user]) do
  transient :gender
  name  { Faker::Internet.user_name}
end

Fabricator(:user_with_email_identity, from: 'User::Account') do
  email {|attributes| Fabricate('User::Identities::Email',
                                address: Faker::Internet.safe_email(name = attributes[:name]))}
end