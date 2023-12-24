class ChatsController < ApplicationController
  before_action :set_chat, only: [:show]

  def index
    @chats = Chat.all
    @chat = Chat.new
    @users = User.where(is_online: true)
  end

  def show
  end

  def create
    @chat = Chat.create!

    redirect_to @chat, notice: 'Chat was successfully created.'
  end

  private

  def set_chat
    @chat = Chat.find_by(token: params[:token])
  end
end

