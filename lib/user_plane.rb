require 'active_support/dependencies'

require 'user_plane/signed_in_constraint'
require 'user_plane/route_concerns'
require 'user_plane/redirect_to_sign_in'
require 'user_plane/session_manager_concern'

require 'user_plane/engine'
require 'user_plane/token_segment'
require 'user_plane/fresh_validator'

require 'email_validator/strict'

require 'user_plane/command'
require 'support_segment'
require 'support_segment/sti_helpers'


module UserPlane
  mattr_accessor :parent_controller
  mattr_accessor :parent_mailer
  mattr_accessor :redirect_to_sign_in

  def self.parent_controller
    @@parent_controller || '::ApplicationController'
  end

  def self.parent_mailer
    @@parent_mailer || 'UserPlane::ApplicationMailer'
  end

  def self.send_emails_from
    "accounts@#{Rails.configuration.action_mailer.default_url_options[:host]}"
  end

  def self.redirect_to_sign_in
    @@redirect_to_sign_in ||= Rack::Builder.new do 
      use ActionDispatch::ShowExceptions, Rails.application.config.exceptions_app
      use ActionDispatch::DebugExceptions, Rails.application
      run RedirectToSignIn.new
    end
  end
end
