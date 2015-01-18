require 'spec_helper'

describe User::SignUp do
  
  describe 'validation' do
  
    it 'happens for the command receiver' do
      p = 'somesecret'
      sign_up_1 = User::SignUp.new(user_name: 'test', email: 'test@example.com', password: p, password_confirmation: p)
      sign_up_1.should be_valid
      sign_up_1.perform!

      sign_up_2 = User::SignUp.new(user_name: 'test', email: 'test@example.com', password: p, password_confirmation: p)
      
      sign_up_2.should_not be_valid

      # WHY: this isn't working - sign_up_2.errors.should have(1).error_on(:email)
      sign_up_2.errors[:email].should have(1).item
      sign_up_2.errors[:user_name].should have(1).item
      sign_up_2.errors[:email_identity].should have(:no).item
    end


  end

end
