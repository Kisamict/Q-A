class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable
  has_many :votes, as: :votable, dependent: :destroy
  
  validates :body, presence: true

  scope :by_best, -> { order(best?: :desc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank 
  
  def best!
    transaction do
      return false if self.best?

      question.answers.update_all(best?: false)
      update!(best?: true)
    end
  end
end
