class UsersController < ApplicationController

  ##
  # New user (sign up)
  def new
    @user = User.new
  end

end
