Rails.application.routes.draw do

  concern :base, UserPlane::RouteConcerns::Base.new()
  concern :sign_up, UserPlane::RouteConcerns::Invites.new()
  concern :email_identity, UserPlane::RouteConcerns::EmailIdentity.new()

  # Users as a resource
  # The User class is a profile class that belongs to the account
  # resources :user, except: [:new, :create] do
  #   concerns :base
  #   concerns :sign_up
  #   concerns :email_identity      
  # end

  # Alternatively as a simple scope
  scope '/account' do
    concerns :base
    concerns :sign_up
    concerns :email_identity
  end

end
