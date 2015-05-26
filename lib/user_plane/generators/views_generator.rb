require 'rails/generators'
require 'user_plane/generators/view/sessions_generator'
require 'user_plane/generators/view/details_generator'
require 'user_plane/generators/view/sign_ups_generator'
require 'user_plane/generators/view/reset_passwords_generator'
require 'user_plane/generators/view/invites_generator'

module UserPlane # :nodoc:
  module Generators # :nodoc:
    class ViewsGenerator < Rails::Generators::Base # :nodoc:

      class_option :template_engine, default: 'erb'
      
      hook_for :'view:sign_ins', default: true do |invoked|
        invoke invoked, ['user/sign_ins']
      end

      hook_for :'view:details', default: true do |invoked|
        invoke invoked, ['user/details']
      end

      hook_for :'view:sign_ups', default: true do |invoked|
        invoke invoked, ['user/sign_ups']
      end

      hook_for :'view:reset_passwords', default: true do |invoked|
        invoke invoked, ['user/reset_passwords']
      end

      hook_for :'view:invites', default: true do |invoked|
        invoke invoked, ['user/invites']
      end

    end
  end
end