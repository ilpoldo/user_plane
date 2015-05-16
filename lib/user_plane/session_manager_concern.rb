module UserPlane
  module SessionManagerConcern
    extend ActiveSupport::Concern

    def session_manager
      @session_manager ||= SessionManager.new(session)
    end
  end
end
