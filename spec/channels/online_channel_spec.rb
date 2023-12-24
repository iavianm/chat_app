require 'rails_helper'

RSpec.describe OnlineChannel, type: :channel do
  let(:user) { create(:user) }

  before do
    stub_connection current_user: user
  end

  it 'subscribes to a stream and calls OnlineService' do
    expect(OnlineService).to receive(:new).with(user: user, is_online: true).and_call_original
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("OnlineChannel")
  end
end
