require 'spec_helper'

describe User::SignUp do
  
  describe 'validation' do
  
    it 'happens for the command receiver' do
      p = 'somesecret'
      sign_up_1 = User::SignUp.new(user_name: 'test', email: 'test@example.com', password: p, password_confirmation: p)
      expect(sign_up_1).to be_valid
      sign_up_1.perform!

      sign_up_2 = User::SignUp.new(user_name: 'test', email: 'test@example.com', password: p, password_confirmation: p)
      
      expect(sign_up_2).not_to be_valid

      expect(sign_up_2.errors[:email].size).to eq(1)
      expect(sign_up_2.errors[:user_name].size).to eq(1)
      expect(sign_up_2.errors[:email_identity].size).to eq(0)
    end


  end

end
