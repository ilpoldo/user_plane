module UserPlane
  class VerificationMailer < UserPlane.parent_mailer.constantize
    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.verification_mailer.address_verification.subject
    #
    def address_verification confirm_email_address
      @confirm_email_address = confirm_email_address

      mail to: confirm_email_address.verification.recipient
    end

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.verification_mailer.password_reset.subject
    #
    def password_reset reset_password
      @reset_password = reset_password

      mail to: reset_password.verification.recipient
    end
  end
end
