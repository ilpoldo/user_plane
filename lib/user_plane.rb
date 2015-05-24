require 'user_plane/signed_in_constraint'
require 'user_plane/route_concerns'
require 'user_plane/session_manager_concern'

require 'user_plane/engine'
require 'user_plane/token_segment'
require 'user_plane/fresh_validator'
require 'user_plane/generators/views_generator'
require 'user_plane/generators/view_generator'

require 'email_validator/strict'

require 'user_plane/command'
require 'support_segment'
require 'support_segment/sti_helpers'


module UserPlane
  mattr_accessor :parent_controller
  mattr_accessor :parent_mailer

  def self.parent_controller
    @@parent_controller || '::ApplicationController'
  end

  def self.parent_mailer
    @@parent_mailer || 'UserPlane::ApplicationMailer'
  end

  def self.send_emails_from
    "accounts@#{Rails.configuration.action_mailer.default_url_options[:host]}"
  end
end
