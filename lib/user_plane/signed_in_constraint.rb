module UserPlane
  # Prevents non signed in users to see specific routes
  class SignedInConstraint

    def matches?(request)
      session = Session.new(request.session)
      session.signed_in?
    end
    
  end  
end
