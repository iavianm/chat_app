class MessageService
  def initialize(body:, user: "Anonymous", chat:)
    @body = body
    @user = user
    @chat = chat
  end

  def perform
    create_message!
    broadcast_message
  end

  private

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

