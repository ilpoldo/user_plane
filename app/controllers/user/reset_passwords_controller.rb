require_dependency "user_plane/application_controller"

module User
  class ResetPasswordsController < ApplicationController

    def new
      @send_password_reset = SendPasswordReset.new
    end

    def create
      @send_password_reset = SendPasswordReset.new(params[:send_password_reset])

      if @send_password_reset.perform
        reset_mail = UserPlane::VerificationMailer.password_reset(@send_password_reset)
        reset_mail.deliver
        redirect_too root_url, notice: :reset_sent
      else
        render 'new'
      end
    end

    def edit
      @reset_password = ResetPassword.new(code: params[:code])
    end

    def update
      @reset_password = ResetPassword.new(params[:reset_password])

      if @reset_password.perform
        redirect_too root_url, notice: :password_reset
      else
        render 'edit'
      end
    end

  end
end
