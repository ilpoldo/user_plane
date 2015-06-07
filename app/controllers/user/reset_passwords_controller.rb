require_dependency "user_plane/application_controller"

module User
  class ResetPasswordsController < ApplicationController

    def new
      @send_password_reset = SendPasswordReset.new
    end

    def create
      @send_password_reset = SendPasswordReset.new(send_password_reset_params)

      if @send_password_reset.perform
        reset_password = User::ResetPassword.new(verification: @send_password_reset.verification)
        reset_mail = UserPlane::VerificationMailer.password_reset(reset_password)
        reset_mail.deliver
        redirect_to root_url, notice: t('.success')
      else
        render 'new'
      end
    end

    def edit
      @reset_password = ResetPassword.new(code: params[:code])
    end

    def update
      @reset_password = ResetPassword.new(reset_password_params)
      if @reset_password.perform
        redirect_to root_url, notice: t('.success')
      else
        render 'edit'
      end
    end

  private

    def reset_password_params
      params.require(:user_reset_password).
             permit(:code, :password, :password_confirmation)
    end

    def send_password_reset_params
      params.require(:user_send_password_reset).
             permit(:email)
    end
  end
end
