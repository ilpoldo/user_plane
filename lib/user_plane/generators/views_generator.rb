require 'rails/generators'

module UserPlane # :nodoc:
  module Generators # :nodoc:
    View = Struct.new(:action, :resource, :attributes)

    class ViewsGenerator < Rails::Generators::Base # :nodoc:
      # include Rails::Generators::ResourceHelpers


      def self.all_views_by_controller
        @all_views_by_controller ||= {
          sessions: [View.new(:new,
                              'sign_in',
                              ['email:string',
                               'password:password'])],
          sign_ups: [View.new(:new,
                              'sign_up',
                              ['email:string',
                               'password:password',
                               'password_confirmation:password'])],
          details: [View.new(:edit,
                             'update_details',
                             ['user_name:string',
                              'email:string',
                              'current_password:password',
                              'password:password',
                              'password_confirmation:password'])],
          reset_passwords: [View.new(:new,
                                     'send_password_reset',
                                     ['recipient:string']),
                            View.new(:edit,
                                     'reset_password',
                                     ['password:password',
                                      'password_confirmation:password'])],
          invites: [View.new(:new,
                             'send_sign_up_invite',
                             ['recipient:string']),
                    View.new(:edit,
                             'sign_up_with_invite',
                             ['user_name:string',
                              'email:string',
                              'password:password',
                              'password_confirmation:password'])]
        }

      end

      argument :controllers, type: :array,
                             default: all_views_by_controller.keys,
                             banner: all_views_by_controller.keys.join(' ')

      # TODO: how to address the single view hook?
      hook_for :view, in: :user_plane, as: :controller do |view_generator|
        # raise view_generator.inspect
        views_by_controllers.each do |controller_name, views|
          views.each do |view|
            invoke view_generator, 'user/' + controller_name,
                                   view.action,
                                   view.attributes,
                                   model_name: view.resource
          end
        end
      end

      # hook_for :template_engine, as: :scaffold, required: true do |template|
      #   controllers_and_actions.each do |controller_name, actions|
      #     invoke template, ['user/' + controller_name, [actions]]
      #   end
      # end


      # def copy_view_files
      #   views_by_controllers.each do |controller, actions|
      #     base_path = File.join("app/views", class_path, controller)
      #     empty_directory base_path
      #     actions.each do |action|
      #       @action = action
      #       formats.each do |format|
      #         @path = File.join(base_path, filename_with_extensions(action, format))
      #         template filename_with_extensions(:view, format), @path
      #       end
      #     end
      #   end
      # end

    protected


      def views_by_controllers
        @views_by_controllers ||= self.class.all_views_by_controller.
          select {|contoller| controllers.include? contoller}
      end

    end
  end
end