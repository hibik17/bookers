class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:edit]

  def index
    @users = User.all
    @book = Book.new
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def search
    @users = User.search(params[:user_search])
    if @users.count != 0
      render :index
    else
      flash[:notice] = "検索対象にヒットしたものはありませんでした。"
      redirect_to users_path
    end
    
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def check_user
    @user = User.find(params[:id])
      unless @user == current_user
        redirect_to user_path(current_user)
      end
  end

end
