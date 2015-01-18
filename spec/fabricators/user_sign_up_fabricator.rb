Fabricator('User::SignUp', aliases: [:user_sign_up]) do
  user_name { Faker::Internet.user_name }
  email     { |attributes| "#{attributes[:user_name].parameterize}@example.com" }

  pw = 'long secret'
  password              pw
  password_confirmation pw
end
