Rails.application.routes.draw do

  concern :base, UserPlane::RouteConcerns::Base.new()
  concern :sign_up, UserPlane::RouteConcerns::Invites.new()
  concern :email_identity, UserPlane::RouteConcerns::EmailIdentity.new()
  concern :auth_endpoint, UserPlane::RouteConcerns::OAuthEndpoint.new()

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
    concerns :email_identity
  end

  concerns :sign_up  

  scope constraints: UserPlane::RouteConcerns.signed_in_constraint do
    get 'signed_in_only', to: 'welcome#index'
  end

  root 'welcome#index'

  get 'signed_in_only', to: UserPlane::RedirectToSignIn.new

  # scope '/foo' do
  #   namespace 'user', path: '/' do
  #     resource :session
  #   end
    
  # end
  # resource :session, namepsace: :user

end
