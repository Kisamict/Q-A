class DailyDigestMailer < ApplicationMailer

  def send_digest(user, questions)
    @recent_questions = questions

    mail to: user.email
  end
end
