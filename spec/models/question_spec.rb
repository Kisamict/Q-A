require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many :attachments }
    
    it { should belong_to(:user) }
  end

  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it { should accept_nested_attributes_for :attachments }
end
