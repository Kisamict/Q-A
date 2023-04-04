require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'associations' do
    it { should belong_to :question }
    it { should belong_to :user }
    it { should have_many :attachments }
    
    it { should accept_nested_attributes_for :attachments }
  end

  context 'validations' do
    it { should validate_presence_of :body }
  end

  context '#best!' do
    let!(:question) { create(:question) }
    let!(:answers)  { create_list(:answer, 3, question: question) }
    let(:answer)    { answers.sample }

    it 'returns true' do
      expect(answer.best!).to be_truthy
    end

    it 'returns false if there answer is already best' do
      answer.update!(best?: true)
      expect(answer.best!).to be_falsey
    end

    it 'changes others question answers best? attribute to false' do
      answer.best!

      answers.excluding(answer).each do |answer|
        answer.reload

        expect(answer.best?).to be_falsey
      end
    end

    it 'changes best? attribute to true' do
      answer.best!

      expect(answer.best?).to be_truthy
    end
  end

  context '.by_best' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let(:answer)   { answers.sample }

    it 'returns answers sorted by best? attribute' do
      answer.best!

      expect(question.answers.by_best.first).to eq answer
    end
  end
end
