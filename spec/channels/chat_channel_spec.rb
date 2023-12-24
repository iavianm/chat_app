require 'rails_helper'

RSpec.describe ChatChannel, type: :channel do
  let(:user) { create(:user) }
  let(:chat) { create(:chat) }

  before do
    stub_connection current_user: user
  end

  it 'successfully subscribes to a chat stream' do
    subscribe(chat: chat.id)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("chat_channel_#{chat.id}")
  end

  describe '#receive' do
    let(:data) { { 'message' => 'Hello' } }

    it 'calls MessageService with received data' do
      subscribe(chat: chat.id)

      expect_any_instance_of(MessageService).to receive(:perform)
      perform :receive, data
    end
  end
end
