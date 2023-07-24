class AddRatingToQuestionsAndAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :rating, :integer, default: 0
    add_column :answers, :rating, :integer, default: 0
  end
end
