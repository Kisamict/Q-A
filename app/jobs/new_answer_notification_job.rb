class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(question)
    question.subscribers.each do |user|
      NewAnswerMailer.send_notification(question.user, question).deliver_later
    end
  end
end
