require_dependency "user_plane/application_controller"

module User
  class ConfirmEmailAddressesController < ApplicationController

    def update
      @confirm_email_address = ConfirmEmailAddress.new(code: params[:code])

      if @confirm_email_address.perform
        redirect_to root_url, notice: :signed_in
      else
        render 'edit'
      end
    end

  end
end
