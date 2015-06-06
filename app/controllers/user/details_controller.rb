require_dependency "user_plane/application_controller"

module User
  class DetailsController < ApplicationController

    def edit
      @update_details = UpdateDetails.new(account: session_manager.account)
    end

    def update
      params
      @update_details = UpdateDetails.new(update_details_params)

      if @update_details.perform
        render 'edit', notice: :updated
      else
        render 'edit'
      end
    end

  private

    def update_details_params
      params.require(:user_update_details).
            permit(:password, :password_confirmation, :email).
            merge(account: session_manager.account)
    end

  end
end
