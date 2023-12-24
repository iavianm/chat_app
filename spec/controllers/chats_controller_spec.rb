require 'rails_helper'

RSpec.describe(ChatsController, type: :controller) do
  describe 'GET #index' do
    let!(:chats) { create_list(:chat, 3) }
    let!(:online_users) { create_list(:user, 2, is_online: true) }

    it 'populates an array of all chats' do
      get :index
      expect(assigns(:chats)).to(match_array(chats))
    end

    it 'assigns new chat to @chat' do
      get :index
      expect(assigns(:chat)).to(be_a_new(Chat))
    end

    it 'populates an array of online users' do
      get :index
      expect(assigns(:users)).to(match_array(online_users))
    end
  end

  describe 'GET #show' do
    let!(:chat) { create(:chat) }

    it 'assigns the requested chat to @chat' do
      get :show, params: { token: chat.token }
      expect(assigns(:chat)).to(eq(chat))
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new chat' do
        expect do
          post(:create, params: { chat: attributes_for(:chat) })
        end.to(change(Chat, :count).by(1))
      end

      it 'redirects to the new chat' do
        post :create, params: { chat: attributes_for(:chat) }
        expect(response).to(redirect_to(Chat.last))
        expect(flash[:notice]).to(eq('Chat was successfully created.'))
      end
    end

    context 'with empty attributes' do
      it 'creates a new chat' do
        expect do
          post(:create, params: { chat: attributes_for(:chat, title: nil) })
        end.to(change(Chat, :count))
      end
    end
  end
end
