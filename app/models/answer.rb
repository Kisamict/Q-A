class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable
  
  validates :body, presence: true

  scope :by_best, -> { order(best?: :desc) }

  def best!
    transaction do
      return false if self.best?

      question.answers.update_all(best?: false)
      update!(best?: true)
    end
  end
end
