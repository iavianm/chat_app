require 'rails_helper'

RSpec.describe 'Api::ChatsController', type: :request do
  describe 'GET /api/chats' do
    let!(:chats) { create_list(:chat, 3) }

    it 'returns all chats' do
      get api_chats_path
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'POST /api/chats/:token/create_message' do
    let!(:chat) { create(:chat) }

    context 'with valid parameters' do
      it 'creates a new message' do
        post create_message_api_chat_path(chat.token), params: { message: { content: 'Hello' } }
        expect(response).to have_http_status(:created)
        expect(chat.messages.last.body).to eq('Hello')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a message' do
        post create_message_api_chat_path(chat.token), params: { message: { content: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(chat.messages).to be_empty
      end
    end

    context 'when chat is not found' do
      it 'returns a not found status' do
        post create_message_api_chat_path('invalid_token'), params: { message: { content: 'Hello' } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
