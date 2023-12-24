class ChatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    @chat = Chat.find(params[:chat])

    stream_from "chat_channel_#{@chat.id}"

    speak("message" => "* * * joined the chat * * *")
  end

  def unsubscribed
    speak("message" => "* * * left the chat * * *")
  end

  def receive(data)
    MessageService.new(body: data["message"], user: current_user, chat: @chat).perform
  end

  def speak(data)
    MessageService.new(body: data["message"], chat: @chat, user: current_user).perform
  end
end
