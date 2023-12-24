require 'rails_helper'

RSpec.describe HandleOfflineJob, type: :job do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }

  it 'queues the job' do
    expect {
      HandleOfflineJob.perform_later(user)
    }.to have_enqueued_job
  end

  it 'calls OnlineService with is_online: false' do
    expect(OnlineService).to receive(:new).with(user: user, is_online: false).and_call_original
    perform_enqueued_jobs { HandleOfflineJob.perform_later(user) }
  end
end
