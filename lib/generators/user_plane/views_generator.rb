require 'rails/generators'

module UserPlane # :nodoc:
  module Generators # :nodoc:
    class ViewsGenerator < Rails::Generators::Base # :nodoc:

      argument :namespace, default: 'user'
      # TODO: make the views below optional
      
      hook_for :'view:sign_ins', default: true do |invoked|
        invoke invoked, ["#{namespace}/sign_ins"]
      end

      hook_for :'view:details', default: true do |invoked|
        invoke invoked, ["#{namespace}/details"]
      end

      hook_for :'view:sign_ups', default: true do |invoked|
        invoke invoked, ["#{namespace}/sign_ups"]
      end

      hook_for :'view:reset_passwords', default: true do |invoked|
        invoke invoked, ["#{namespace}/reset_passwords"]
      end

      hook_for :'view:invites', default: true do |invoked|
        invoke invoked, ["#{namespace}/invites"]
      end

    end
  end
end