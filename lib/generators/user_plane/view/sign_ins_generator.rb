require 'rails/generators'
require 'generators/user_plane/view/helpers'

module UserPlane # :nodoc:
  module Generators # :nodoc:
    module View
      class SignInsGenerator < Rails::Generators::NamedBase # :nodoc:
        include UserPlane::Generators::View::Helpers

        def copy_view_files
          create_root_folder
          
          view_for_resource :new, 'sign_in', ['email:string', 'password:string']
        end
      end      
    end
  end
end