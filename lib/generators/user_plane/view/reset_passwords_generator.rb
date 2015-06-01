require 'rails/generators'
require 'generators/user_plane/view/helpers'

module UserPlane # :nodoc:
  module Generators # :nodoc:
    module View
      class ResetPasswordsGenerator < Rails::Generators::NamedBase # :nodoc:
        include UserPlane::Generators::View::Helpers

        def copy_view_files
          create_root_folder
          
          view_for_resource :new, 'send_password_reset', ['email:string']
          #TODO: add a hidden field for the password reset code
          view_for_resource :edit, 'reset_password', ['password:password',
                                                      'password_confirmation:password']
        end

      end      
    end
  end
end