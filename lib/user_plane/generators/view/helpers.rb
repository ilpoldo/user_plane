require 'rails/generators/resource_helpers'

module UserPlane # :nodoc:
  module Generators # :nodoc:
    module View
      module Helpers# :nodoc:
        extend ActiveSupport::Concern

        included do
          include Rails::Generators::ResourceHelpers
          # TODO: move this in classmethods
          source_root File.expand_path("../../templates", __FILE__)
          hide!

          class_option :template_engine, default: 'erb'

          hook_for :template_engine, as: :scaffold do |template_engine|
            source_paths.append template_engine.source_root        
          end
        end

      protected

        def create_root_folder
          empty_directory File.join("app/views", controller_file_path)
        end

        def view_for_resource view, model_name, attributes

          self.name = model_name
          self.attributes = attributes
          assign_names! name
          parse_attributes!
          
          formats.each do |format|
            templatename = filename_with_extensions('_form', format)
            filename = filename_with_extensions(view, format)
            template templatename, File.join("app/views", controller_file_path, filename)
          end
        end

        attr_accessor :attributes, :name

        def formats
          [format]
        end

        def format
          :html
        end

        def handler
          options[:template_engine]
        end

        def filename_with_extensions(name, format = self.format)
          [name, format, handler].compact.join(".")
        end

      end
    end
  end
end