Rails.application.routes.draw do

  concern :sign_up, UserPlane::RouteConcerns::SignUp.new()
  concern :email_identity, UserPlane::RouteConcerns::EmailIdentity.new()

  scope '/accounts' do
    concerns :sign_up
    concerns :email_identity
  end

end
