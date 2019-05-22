class UsersController < ApplicationController


  def new
    @user = User.new

  end

  def create
    @user = User.new(strong_params)
    if password_confirmation != true
      flash[:notice] = "Those passwords don't match."
      render :new
    elsif email_confirmation != true
      flash[:notice] = "That email address is already taken."
      render :new
    elsif @user.save!
      session[:user_id] = @user.id
      flash[:notice] = "You are now registered and logged in."
      redirect_to profile_path
    else
      flash[:notice] = "That didn't work, please try again."
      render :new
    end
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  private

  def email_confirmation
    User.email_string.all? do |email|
      params[:user][:email] != email
    end
  end

  def password_confirmation
    if params["user"]["password"] == params["user"]["confirm_password"]
      true
    else
      false
    end
  end

  def strong_params
    params.require(:user).permit(:name, :address, :city, :state, :zip, :email, :password)
  end

end
