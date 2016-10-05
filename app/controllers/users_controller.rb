class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :create, :new]
  before_action :verify_admin, only: :destroy	
  before_action :find_user, except: [:create, :new, :index]
  before_action :correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit
  end

  def index
    @users = User.activatedUser.paginate page: params[:page]
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def show
    @microposts = @user.microposts.paginate page: params[:page]
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

  def correct_user
    redirect_to root_url unless @user == current_user
  end
end
