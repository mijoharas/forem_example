class SessionsController < ApplicationController
   
  ##
  # New action for the sign in page
  def new
  end

  ##
  # Create action to create a session (meaning the user will be logged in)
  # has to be able to handle authenticated and unauthenticated
  # users
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if params[:remember_me]
        sign_in user
      else
        cookies[:remember_token] = user.remember_token
      end
      redirect_back_or root_url
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
      # MY_LOGGER.info "this will break guard tests"
    end
  end

  ##
  # Destroy action for signing out
  def destroy
    sign_out
    redirect_to root_url
  end
end
