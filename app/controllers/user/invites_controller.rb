require_dependency "user_plane/application_controller"

module User
  class InvitesController < ApplicationController

    def new
      @send_sign_up_invite = SendSignUpInvite.new
    end

    def create
      @send_sign_up_invite = SendSignUpInvite.new(params[:send_sign_up_invite])

      if @send_sign_up_invite.perform
        redirect_to :new, notice: :success
      else
        render 'new'
      end      
    end

    def edit
      @sign_up_with_invite = SignUpWithInvite.new(code: params[:code])
      @sign_up_with_invite.email = @sign_up_with_invite.invite.recipient
    end

    def update
      @sign_up_with_invite = SignUpWithInvite.new(sign_up_params).sign_up_with(Identities::Email)

      perform_sign_up @sign_up_with_invite
    end

    def oauth_callback
      # TODO: do I need to check the provider param? There is on in oauth_data
      # and one in params.
      oauth_data = request.env["omniauth.auth"]
      #FIXME: the way the user_name is inferred might work for facebook only
      oauth_params = {oauth_data: oauth_data,
                      user_name: oauth_data[:info][:nickname],
                      code: params[:sign_up_with_invite_code]}
      # TODO: The host app should be able to do a sign_up here instead 
      @sign_up_with_invite = SignUpWithInvite.new(oauth_params).sign_up_with(Identities::OAuth)

      perform_sign_up @sign_up_with_invite
    end


  private

    def sign_up_params
      params.require(:user_sign_up_with_invite).
             permit(:email, :password, :password_confirmation, :user_name, :code)
    end

    def perform_sign_up sign_up
      if sign_up.perform
        session_manager.identity = sign_up.identity
        redirect_to root_url, notice: t('.success')
      else
        render 'edit'
      end      
    end

  end
end
