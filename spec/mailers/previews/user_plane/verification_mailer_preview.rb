module UserPlane
  # Preview all emails at http://localhost:3000/rails/mailers/user_plane/verification_mailer
  class VerificationMailerPreview < ActionMailer::Preview

    # Preview this email at http://localhost:3000/rails/mailers/user_plane/verification_mailer/address_verification
    def address_verification
      VerificationMailer.address_verification
    end

    # Preview this email at http://localhost:3000/rails/mailers/user_plane/verification_mailer/password_reset
    def password_reset
      VerificationMailer.password_reset
    end

  end
end
