require 'user_plane/route_concerns'

require 'user_plane/engine'
require 'user_plane/token_segment'
require 'user_plane/fresh_validator'

require 'email_validator/strict'

require 'imperator'
require 'support_segment'
require 'support_segment/sti_helpers'

module UserPlane
  mattr_accessor :parent_controller
  mattr_accessor :parent_mailer

  def self.parent_controller
    @@parent_controller || '::ApplicationController'
  end

  def self.parent_mailer
    @@parent_mailer || '::ActionMailer::Base'
  end
end
