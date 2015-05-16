class User::Guest
  
  def self.find_or_create_from_session session
    self.new(session)
  end

  def initialize session
    @session = session
  end

end
