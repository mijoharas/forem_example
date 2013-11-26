module SessionsHelper

  ##
  # Signs a user in, creates a cookie so they stay signed in across
  # multiple pages
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  ##
  # Tells you if the user is signed in
  def signed_in?
    !current_user.nil?
  end

  ##
  # Setter for the current_user
  def current_user=(user)
    @current_user = user
  end

  ##
  # Getter for the current_user, either uses the instance variable
  # @current_user or if that is not present it gets the user ebject
  # from the users cookie
  def current_user
    @current_user ||= User.find_by(remember_token: cookies[:remember_token])
  end

  ##
  # Checks if the current user is the same as an object
  def current_user?(user)
    user == current_user
  end

  ##
  # Checks if the user is signed in and if not redirects to 
  # the signin url after saving the place the user wants to go
  # (so that when they are signed in we can "friendly forward"
  #  them to the correct location)
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  ##
  # Signs a user out
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  ##
  # Redirects a user to where they wanted to go before they needed
  # to sign in or to the route provided
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)    
  end

  ##
  # Stores a location that the user is planning to visit
  def store_location
    session[:return_to] = request.url
  end

end
