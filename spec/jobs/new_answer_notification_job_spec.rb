require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let!(:question) { create(:question) }

  it 'sends notification' do
    expect(NewAnswerMailer).to receive(:send_notification).with(question.user).and_call_original
    NewAnswerNotificationJob.perform_now(question.user)
  end
end
