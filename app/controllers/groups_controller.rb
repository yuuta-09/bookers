class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_owner, only: [:edit, :update]
  
  def new
    @group = Group.new
  end

  def index
    @groups = Group.all
    @book = Book.new
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def join
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to groups_path
  end

  def leave
    @group = Group.find(params[:group_id])
    @group.users.delete(current_user)
    redirect_to groups_path
  end

  def new_mail
    @group = Group.find(params[:group_id])
  end

  def send_mail
    @group = Group.find(params[:group_id])
    @mail_title = params[:mail_title]
    @mail_body = params[:mail_body]

    event = {
      :group => @group,
      :title => @mail_title,
      :body => @mail_body
    }

    NoticeMailer.send_notification(event)
  end

  private
  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  def ensure_correct_owner
    group = Group.find(params[:id])
    unless group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
