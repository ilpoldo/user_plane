require_dependency "user_plane/application_controller"

module User
  class SignInsController < ApplicationController

    def new
      @sign_in = SignIn.new()
    end

    def create
      @sign_in = SignIn.new(sign_in_params).sign_in_with(Identities::Email)

      perform_sign_in @sign_in
    end

    def oauth_callback
      # TODO: do I need to check the provider param? There is on in oauth_data
      # and one in params.
      oauth_data = request.env["omniauth.auth"]
      oauth_error = request.env["omniauth.error"]

      # TODO: The host app should be able to do a sign_up here instead 
      @sign_in = SignIn.new(oauth_data: oauth_data,
                            oauth_error: oauth_error).sign_in_with(Identities::OAuth)

      perform_sign_in @sign_in
    end

    def destroy
      session_manager.sign_out
      redirect_to root_url, notice: t('.success')
    end

  private

    def sign_in_params
      params.require(:user_sign_in).permit(:email, :password)
    end

    def perform_sign_in sign_in
      if sign_in.perform
        session_manager.remember_page nil
        session_manager.identity = sign_in.identity
        redirect_to session_manager.previous_page || root_url,
                    notice: t('.success')
      else
        render 'new'
      end
    end

  end
end
