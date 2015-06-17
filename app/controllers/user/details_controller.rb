require_dependency "user_plane/application_controller"

module User
  class DetailsController < ApplicationController

    cattr_accessor :permitted do
      [:name, :password, :password_confirmation, :email]
    end

    before_action :initialize_update_details

    def edit
      @update_details
    end

    def update
      @update_details.attributes = update_details_params

      if @update_details.perform
        if email_verification = @update_details.email_verification
          confirm_email_address = User::ConfirmEmailAddress.new(verification: email_verification)
          confirm_mail = UserPlane::VerificationMailer.address_verification(confirm_email_address)
          confirm_mail.deliver_now
          # TODO: flash a warning about the email address
        end
        render 'edit', notice: :updated
      else
        render 'edit'
      end
    end

  private

    def initialize_update_details
      @update_details = UpdateDetails.new(account: session_manager.account)
    end

    def update_details_params
      # TODO: drive the permitted 
      params.require(:user_update_details).
            permit(*self.class.permitted)
    end

  end
end
