require_dependency "user_plane/application_controller"

module User
  class SessionsController < ApplicationController

    def new
      @sign_in = SignIn.new
    end

    def create
      @sign_in = SignIn.new(params).sign_in_with(Identities::Email)

      if @sign_in.perform
        session_manager.identity = @sign_in.identity
        redirect_to root_url, notice: :signed_in
      else
        render 'new'
      end
    end

    def destroy
      session_manager.sign_out
      redirect_to root_url, notice: :signed_out
    end

  end
end
