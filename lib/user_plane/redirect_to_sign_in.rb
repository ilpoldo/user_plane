module UserPlane
  class RedirectToSignIn

    def initialize route_options={}
      default_route = {controller: 'user/sign_ins', action: :new}
      @sign_in_route = default_route.merge(route_options)
    end

    def call env
      session_manager = SessionManager.new(env['rack.session'])
      request_path = "#{env['PATH_INFO']}?#{env['QUERY_STRING']}"
      session_manager.remember_page(request_path)

      sign_in_path = env['action_dispatch.routes'].path_for(@sign_in_route)
      [301, {'Location' => sign_in_path}, ['Redirecting to the sign in page']] 
    end
  end
end