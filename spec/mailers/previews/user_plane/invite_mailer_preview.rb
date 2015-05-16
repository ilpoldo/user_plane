module UserPlane
  # Preview all emails at http://localhost:3000/rails/mailers/user_plane/invite_mailer
  class InviteMailerPreview < ActionMailer::Preview

    # Preview this email at http://localhost:3000/rails/mailers/user_plane/invite_mailer/invite
    def invite
      InviteMailer.invite
    end

  end
end
