class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    questions = Question.daily_questions.to_a
    User.find_each { |user| DailyDigestMailer.send_digest(user, questions).deliver_later }
  end
end
