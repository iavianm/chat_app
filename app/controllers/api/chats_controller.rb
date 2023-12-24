module Api
  class ChatsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      @chats = Chat.all
      render json: @chats
    end

    def create_message
      @chat = Chat.find_by(token: params[:token])
      if @chat.nil?
        return render json: { error: "Chat not found" }, status: :not_found
      end

      service = MessageService.new(body: message_params[:content], chat: @chat)
      @message = service.perform

      if @message.persisted?
        render json: @message, status: :created
      else
        render json: @message.errors, status: :unprocessable_entity
      end
    end

    private

    def message_params
      params.require(:message).permit(:content)
    end
  end
end

