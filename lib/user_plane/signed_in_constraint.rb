module UserPlane
  # Prevents non signed in users to see specific routes
  class SignedInConstraint

    def initialize(session_model=nil)
      @session_model = (session_model || 'Session').constantize
    end
        
    def matches?(request)
      session = @session_model.constantize.new(request.session)
      session.signed_in?
    end
    
  end  
end
