require 'rails_helper'

RSpec.describe(MessageService) do
  let(:chat) { create(:chat) }
  let(:user) { create(:user) }
  let(:message_body) { 'Test message' }

  context 'with a given user' do
    let(:service) { MessageService.new(body: message_body, user:, chat:) }

    it 'creates a new message and broadcasts it' do
      expect do
        service.perform
      end.to(change(Message, :count).by(1))

      expect(Message.last.body).to(eq(message_body))
      expect(Message.last.user).to(eq(user))
      expect(Message.last.chat).to(eq(chat))

      expect do
        service.perform
      end.to(have_broadcasted_to("chat_channel_#{chat.id}").
        with(a_hash_including(message: a_string_including(message_body))))
    end
  end

  context 'without a given user (anonymous)' do
    let(:service) { MessageService.new(body: message_body, chat:) }

    it 'creates an anonymous message and broadcasts it' do
      expect do
        service.perform
      end.to(change(Message, :count).by(1))

      expect(Message.last.body).to(eq(message_body))
      expect(Message.last.user.nickname).to(eq('Anonymous'))
      expect(Message.last.chat).to(eq(chat))

      expect do
        service.perform
      end.to(have_broadcasted_to("chat_channel_#{chat.id}").
        with(a_hash_including(message: a_string_including(message_body))))
    end
  end
end
