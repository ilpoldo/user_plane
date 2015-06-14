require 'user_plane/omniauth'

UserPlane::OmniAuth.middleware do
  provider :facebook, 'dummy', 'dummy'
end
