require 'rails/generators'
require 'generators/user_plane/view/helpers'

module UserPlane # :nodoc:
  module Generators # :nodoc:
    module View
      class InvitesGenerator < Rails::Generators::NamedBase # :nodoc:
        include UserPlane::Generators::View::Helpers

        def copy_view_files
          create_root_folder
          
          view_for_resource :new, 'send_sign_up_invite', ['recipient:string']
          #TODO: add a hidden field for the invite code
          view_for_resource :edit, 'sign_up_with_invite', ['user_name:string',
                                                           'email:string',
                                                           'password:password',
                                                           'password_confirmation:password']
        end
      end      
    end
  end
end