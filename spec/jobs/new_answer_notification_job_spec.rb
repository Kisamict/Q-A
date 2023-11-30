require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:question) { create(:question) }
  let(:subscriptions) { create_list(:subscription, 5, question: question) }
  let(:subscribers) { question.subscribers }

  it 'sends notification to all subscribers' do
    subscribers.each do |user|
      expect(NewAnswerMailer).to receive(:send_notification).with(user, question).and_call_original
    end

    NewAnswerNotificationJob.perform_now(question)
  end
end
