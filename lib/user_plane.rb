require 'user_plane/engine'
require 'user_plane/token_segment'
require 'user_plane/fresh_validator'
require 'email_validator/strict'

require 'imperator'
require 'support_segment'
require 'support_segment/sti_helpers'

module UserPlane
  mattr_accessor :parent_controller

  def self.parent_controller
    (@@parent_controller || '::ApplicationController').constantize
  end
end
