class NewAnswerMailer < ApplicationMailer
  def send_notification(user, question)
    @question = question

    mail to: user.email
  end
end
