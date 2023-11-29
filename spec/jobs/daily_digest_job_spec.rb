require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:recent_questions) { create_list(:question, 2) }

  it 'sends daily digest' do
    User.find_each do |user|
      expect(DailyDigestMailer).to receive(:send_digest).with(user, recent_questions.to_a).and_call_original
    end
    
    DailyDigestJob.perform_now
  end
end
