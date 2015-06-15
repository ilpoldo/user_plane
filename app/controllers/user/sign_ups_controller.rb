require_dependency "user_plane/application_controller"

module User
  class SignUpsController < ApplicationController

    def new
      @sign_up = SignUp.new
    end

    def create
      @sign_up = SignUp.new(sign_up_params).sign_up_with(Identities::Email)

      perform_sign_up @sign_up
    end

    def oauth_callback
      # TODO: do I need to check the provider param? There is on in oauth_data
      # and one in params.
      oauth_data = request.env["omniauth.auth"]

      # FIXME: the way the user_name is inferred might work for facebook only
      oauth_params = {oauth_data: oauth_data,
                      user_name: oauth_data[:info][:nickname]}
      # TODO: The host app should be able to do a sign_up here instead 
      @sign_up = SignUp.new(oauth_params).sign_in_with(Identities::OAuth)

      perform_sign_up @sign_up
    end

  private

    def sign_up_params
      params.require(:user_sign_up).
             permit(:email, :password, :password_confirmation, :user_name)
    end

    def perform_sign_up sign_up
      if sign_up.perform
        session_manager.identity = sign_up.identity
        redirect_to root_url, notice: t('.success')
      else
        render 'new'
      end      
    end

  end
end
