class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user
  
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  
  validates :body, presence: true

  after_create :send_notification

  scope :by_best, -> { order(best?: :desc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank 
  
  def best!
    transaction do
      return false if self.best?

      question.answers.update_all(best?: false)
      update!(best?: true)
    end
  end

  private

  def send_notification
    NewAnswerNotificationJob.perform_later(question)
  end
end
