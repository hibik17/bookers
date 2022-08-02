# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: %i[edit update]
  before_action :ensure_guest_user, only: [:edit]

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end

    # today's post count
    @todays_post = Book.where(user_id: @user.id, created_at: Time.current.at_beginning_of_day...Time.current).count

    # last day's post count
    @lastdays_post = Book.where(user_id: @user.id,
                                created_at: (Time.current - 1.day).at_beginning_of_day...(Time.current - 1.day).at_end_of_day).count

    # day"s_ratio
    if @todays_post.zero? && @lastdays_post.zero?
      @ratio = 0
    elsif @todays_post.zero?
      @ratio = - (@lastdays_post * 100)
    elsif @lastdays_post.zero?
      @ratio = (@todays_post * 100)
    end

    # this week's post counte
    @week_post = Book.where(user_id: @user.id,
                            created_at: (Time.current - 6.day).at_beginning_of_day...Time.current).count

    # last week's post count
    @lastweek_post = Book.where(user_id: @user.id,
                                created_at: (Time.current - 13.day).at_end_of_day...(Time.current - 7.day)).count

    # week ratio
    if @week_post.zero? && @lastweek_post.zero?
      @week_ratio = 0
    elsif @week_post.zero?
      @week_ratio = - (@lastweek_post * 100)
    elsif @lastweek_post.zero?
      @week_ratio = (@week_post * 100)
    end

    # count the post in a week
    @day_array = [1, 2, 3, 4, 5, 6, 7]

    # define the array to maintain the post count of each day
    @weekposts_array = []

    # find post by loop
    @day_array.each do |i|
      day_num = i - 1
      @weekposts_array.push(Book.where(user_id: @user.id,
                                       created_at: (Time.current - day_num.day).at_beginning_of_day...(Time.current - day_num.day)).count)
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'You have updated user successfully.'
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    redirect_to user_path(current_user) unless @user == current_user
  end

  def ensure_guest_user
    user = User.find(params[:id])
    redirect_to user_path(current_user), notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。' if @user.name == 'guestuser'
  end
end
