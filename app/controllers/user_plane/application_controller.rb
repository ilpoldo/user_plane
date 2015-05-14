module UserPlane
  class ApplicationController < UserPlane.parent_controller.constantize
    include UserPlane::SessionManagerConcern
  end
end
