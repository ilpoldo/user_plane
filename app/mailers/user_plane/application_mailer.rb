module UserPlane
  class ApplicationMailer < ActionMailer::Base
    include Rails.application.routes.url_helpers
    
    default from: UserPlane.send_emails_from

  end  
end
