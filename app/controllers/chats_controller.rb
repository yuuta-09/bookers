class ChatsController < ApplicationController
  before_action :user_related?, only: [:show]
  
  # chat画面
  def show
    @user = User.find(params[:id])
    # user_roomsモデルのroom_idカラムを取得
    rooms = current_user.user_rooms.pluck(:room_id)
    user_room = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    # user_roomがなかった場合はuser_roomを作成
    if user_room
      @room = user_room.room
    else
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end

    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end

  # chatの作成
  def create
    @chat = current_user.chats.new(chat_params)
    render :validater unless @chat.save
  end

  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def user_related?
    user = User.find(params[:id])
    unless current_user.following_each?(user)
      redirect_to books_path
    end
  end
end
