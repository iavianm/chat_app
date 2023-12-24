class ChatsController < ApplicationController
  before_action :set_chat, only: [:show]

  def index
    @chats = Chat.all
    @chat = Chat.new
    @users = User.where(is_online: true)
  end

  def show; end

  def create
    @chat = Chat.new(chat_params)
    if @chat.save
      redirect_to(@chat, notice: 'Chat was successfully created.')
    else
      @chats = Chat.all
      @users = User.where(is_online: true)
      render(:index)
    end
  end

  private

  def set_chat
    @chat = Chat.find_by(token: params[:token])
  end

  def chat_params
    params.require(:chat).permit(:title)
  end
end
