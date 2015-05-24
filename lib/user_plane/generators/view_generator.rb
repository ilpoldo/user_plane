require 'rails/generators/resource_helpers'

module UserPlane # :nodoc:
  module Generators # :nodoc:
    class ViewGenerator < Rails::Generators::Base # :nodoc:
      include Rails::Generators::ResourceHelpers

      hide!

      argument :name, required: true
      argument :view, required: true
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      # TODO: find the correct view templates
      source_root File.expand_path("../templates", __FILE__)

      def create_root_folder
        empty_directory File.join("app/views", controller_file_path)
      end

      def copy_view_files
        formats.each do |format|
          filename = filename_with_extensions(view, format)
          template filename, File.join("app/views", controller_file_path, filename)
        end
      end

    end
  end
end