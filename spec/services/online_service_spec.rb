require 'rails_helper'

RSpec.describe(OnlineService) do
  let(:user) { create(:user, is_online: false) }
  let(:service) { OnlineService.new(user:, is_online: true) }

  it 'updates the user online status' do
    expect do
      service.perform
    end.to(change { user.reload.is_online }.from(false).to(true))
  end

  it 'broadcasts to OnlineChannel' do
    expect do
      service.perform
    end.to(have_broadcasted_to('OnlineChannel').with(a_hash_including(user: hash_including('id' => user.id, 'is_online' => true))))
  end
end
