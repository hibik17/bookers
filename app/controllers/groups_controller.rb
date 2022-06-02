class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @book = Book.new
    @groups = Group.all
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def join_group
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to request.referer
  end

  def destroy
    Group.find(params[:id]).group_users.find_by(user_id: current_user.id).destroy
    redirect_to request.referer
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      @group.users << current_user
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end

  def notice_event
  end

  def create_event_mail
    @group_member = Group.find(params[:group_id]).group_users

    @group_member.each do |member|
      EventMailer.with(user_id: member.user.id, title: params[:title], content: params[:content]).notice_email.deliver_later
    end

    render :confirm_mail
  end

  def confirm_mail
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
