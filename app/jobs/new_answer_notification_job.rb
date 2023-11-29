class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(question)
    NewAnswerMailer.send_notification(question.user, question).deliver_now
  end
end
