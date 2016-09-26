class UsersController < ApplicationController
  before_action :find_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = "Welcome to the Sample App!"	
      redirect_to @user
    else
      render :new
    end
  end

  private

  def find_user
    @user= User.find_by_id params[:id]
    unless @user
      flash[:danger] = "we can not find user"
      redirect_to root_path
  	end
  end

  def user_params
    params.require(:user).permit :name, :email, :password, 
      :password_confirmation 
  end
end
