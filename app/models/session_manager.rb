class SessionManager

  class << self
    attr_accessor :identity_lifetime
  end

  # What else can go in the session
  # Analytics stuff
  # Location information
  # some form of robot detection

  @identity_lifetime = 1.hour  

  def initialize(request_session)
    @session = request_session
    refresh!
    @session[:created_at] ||= Time.now    
    @session[:previous_page] = @session[:last_page]
  end
  
  def created_at
    @session[:created_at]
  end
  
  # Stores the url in the user session to provide a redirect after the login.
  def remember_page(url)
    @session[:last_page] = url
  end

  # Provides the url to redirect to for a login.
  def previous_page
    @session[:previous_page]
  end
  
  def last_announcements_seen_on
    @session[:last_announcements_seen_on] ||= 1
  end
  
  def last_announcements_seen!
    @session[:last_announcements_seen_on] = Time.now
  end
  
  # Sets into the session the identity with which the user has logged in.
  def identity=(identity)
    unless identity.nil?
      @session[:identity] = {id_token: identity.serialize,
                             expires_at: SessionManager.identity_lifetime.from_now}
    else
      @session[:identity] = nil
    end
    @identity = identity
  end
  
  # Deletes the user login information for the session.
  def sign_out
    self.identity = nil
  end

  # Retrieves the identity from using the identity id and creation time stored in the session
  def identity
    identity = @session[:identity]
    if identity &&  identity[:expires_at] > Time.now 
      @identity ||= User::Identity.deserialize!(identity[:id_token])
    else
      nil
    end
  end

  # Retrieves the user account from the database through an identity.
  def user
    identity ? identity.account : User::Guest.find_or_create_from_session(@session)
  end

  # Returns _true_ if the user is logged in, otherwise returns _false_.
  def signed_in?
    identity ? true : false
  end
      
  # Sets the login expiration to one year from now.
  def remember_me!
    @session[:identity][:expires_at] = 1.year.from_now
  end
  
private
  
  # Renews session expiration for the next 45 minutes if the session is still fresh
  def refresh!
    identity = @session[:identity]
    if signed_in? && identity[:expires_at] < SessionManager.identity_lifetime.from_now 
      identity[:expires_at] = SessionManager.identity_lifetime.from_now
    end
  end

end

