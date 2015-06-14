require 'omniauth'

module UserPlane
  module OmniAuth

    # Lets actiondispatch figure out the request path. Looks like request_path
    # needs to return the callback path to generate the correct link
    def self.request_path_criteria_for provider
      lambda do |env|
        path_parameters = env["action_dispatch.request.path_parameters"]
        path_parameters[:action] == 'oauth_request' && UserPlane::OmniAuth.custom_path(env)        
      end
    end

    def self.callback_path_criteria_for provider
      lambda do |env|
        path_parameters = env["action_dispatch.request.path_parameters"]
        path_parameters[:action] == 'oauth_callback'
      end
    end

    def self.custom_path env
      path_parameters = env["action_dispatch.request.path_parameters"]
      custom_callback_path = path_parameters.merge(action: 'oauth_callback',
                                                   only_path: true)
      env['action_dispatch.routes'].url_for custom_callback_path
    end

    # Configures the omniauth middleware for the application
    def self.middleware &block
      controllers = [User::SignInsController,
                     User::SignUpsController,
                     User::InvitesController]

      controllers.each do |controller|
        controller.middleware.use Builder, &block
      end
    end

    # Wraps OmniAuth::Builder to provide custom callback urls driven by the routes
    class Builder < ::OmniAuth::Builder
      def provider(klass, *args, &block)
        options = args.extract_options!
        args << options.merge(request_path:  UserPlane::OmniAuth.request_path_criteria_for(klass),
                              callback_path: UserPlane::OmniAuth.callback_path_criteria_for(klass))
        super
      end
    end
  end
end