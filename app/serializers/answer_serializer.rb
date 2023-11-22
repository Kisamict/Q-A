class AnswerSerializer < ActiveModel::Serializer
  attributes %i[id question_id user_id body rating best? created_at updated_at]
end