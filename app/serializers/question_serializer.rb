class QuestionSerializer < ActiveModel::Serializer
  attributes %i[id user_id title body rating created_at updated_at]
  
  has_many :comments
end
