class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  
  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  scope :daily_questions, -> { where(created_at: (-1.day.from_now..Time.zone.now))}
end
