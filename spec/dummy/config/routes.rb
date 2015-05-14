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

  
  scope '/account' do
    concerns :base
    concerns :email_identity
  end

  # Alternatively as a simple scope
  concerns :sign_up

  root 'welcome#index'

  # scope '/foo' do
  #   namespace 'user', path: '/' do
  #     resource :session
  #   end
    
  # end
  # resource :session, namepsace: :user

end
