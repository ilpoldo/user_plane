[![CircleCI](https://circleci.com/gh/ilpoldo/user_plane.svg?style=svg)](https://circleci.com/gh/ilpoldo/user_plane)
[![Code Climate](https://codeclimate.com/github/ilpoldo/user_plane/badges/gpa.svg)](https://codeclimate.com/github/ilpoldo/user_plane)
UserPlane
=========

Customisable authentication component for rails apps inspired by [Component-Based Rails Applications](http://cbra.info).

Getting Started
---------------

Add `gem 'user_plane'` to your Gemfile and run `bundle install`

### Migrations


Create all the necessary user tables:

    rake db:migrate

### Routes

Mount the authentication routes in your main application:

    # Setting up the user routes
    concern :base, UserPlane::RouteConcerns::Base.new()
    concern :sign_up,  UserPlane::RouteConcerns::SignUp.new()

    # Email verification and password reset:
    concern :email_identity,  UserPlane::RouteConcerns::EmailIdentity.new()
    # Oauth endpoint:
    concern :auth_endpoint,  UserPlane::RouteConcerns::OAuthEndpoint.new()
 
    concerns :sign_up
    
    scope '/account' do
      concerns :base
      concerns :email_identity
    end

Use the signed in constraint to enforce being signed in to prevent requests without sign in to find certain resources, and add a catch to redirect it to a login page.

    scope constraints: UserPlane::RouteConcerns.signed_in_constraint do
      get 'members_only' => 'members_only#show'
    end

    get 'members_only', to: UserPlane.redirect_to_sign_in

To allow only invite holders to sign up swap it for the invite system use `Invites` instead of `SignUp` routes:

    concern :sign_up,  UserPlane::RouteConcerns::Invites.new()

### Initialiser

Activate omniauth providers in the initialiser file

    require 'user_plane/omniauth'

    UserPlane::OmniAuth.middleware do
      provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
        provider_ignores_state: true
    end

### Generating the default views

The generator is a bit of a work in progress, try:

    rails g user_plane:views

Customising the Model
---------------------

To add application-specific functionality, simply open the class again.
For examle in the main application's `app/models/user/account.rb` you can:

    require_dependency UserPlane::Engine.root.join('app', 'models', 'user', 'account').to_s

    class User::Account
      has_one :profile
    end

and create a migration for `user_account`


This project uses MIT-LICENSE.
