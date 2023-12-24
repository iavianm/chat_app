class MessageService
  def initialize(body:, user: nil, chat:)
    @body = body
    @user = user
    @chat = chat
  end

  def perform
    find_or_create_anonymous_user unless @user
    create_message!
    broadcast_message
    @message
  rescue ActiveRecord::RecordInvalid => e
    e.record
  end

  private

  def find_or_create_anonymous_user
    @user = User.find_or_create_by!(nickname: 'Anonymous')
  end

  def create_message!
    @message ||= Message.create! body: @body, chat: @chat, user: @user
  end

  def broadcast_message
    ActionCable.server.broadcast("chat_channel_#{@chat.id}",
                                 { message: render_message })
  end

  def render_message
    ApplicationController.renderer.render(partial: 'messages/message', locals: {
      message: @message
    })
  end
end

