# class Dog < Struct.new(:able_to_growl?, :able_to_bark?, :able_to_jump?, :able_to_flee?)
# end
# snuff = Dog.new(true, true, false, true)
# scooby_doo = Dog.new(false, true, true, true)
# scrappy_doo = Dog.new(true, false, true, true)

# shared_examples 'a normal dog' do |growl: true, bark: true, jump: true|
#   it { is_expected.to be_able_to_growl } if growl
#   it { is_expected.to be_able_to_bark } if bark
#   it { is_expected.to be_able_to_jump } if jump
#   it { is_expected.to be_able_to_flee }
# end

# describe 'Dogs behavior' do
#   context 'Snuff' do
#     subject(:snuff) { Dog.new(true, true, false, true) }
#     it_behaves_like 'a normal dog', jump: false
#   end

#   context 'Scooby-Doo' do
#     subject(:scooby_doo) { Dog.new(false, true, true, true) }
#     it_behaves_like 'a normal dog', growl: false
#   end

#   context 'Scrappy-Doo' do
#     subject(:scrappy_doo) { Dog.new(true, false, true, true) }
#     it_behaves_like 'a normal dog', bark: false
#   end
# end

# RSpec.shared_examples 'Fillable' do |received_capacity|
#   describe 'full?' do
#     context "when the #{described_class.downcase}" is do
#       context 'not full' do
#         include_context 'filled'
#         it 'returns false' do
#           expect(subject).to be_falsey
#         end
#       end
  
#       context 'is full' do
#         include_context 'filled' do
#           let(:current_capacity) { received_capacity }
#         end
#         it 'returns true' do
#           expect(subject).to be_truthy
#         end
#       end
#     end
#   end
# end
# # spec/models/bottle_spec.rb
# RSpec.describe Bottle, type: :model do
#   it_behaves_like 'Fillable', 330
# end
# # spec/models/bowl_spec.rb
# RSpec.describe Bowl, type: :model do
#   it_behaves_like 'Fillable', 600
# end

require 'rails_helper'

shared_examples 'Controller Votable' do
  subject     { create(described_class.controller_path.classify.constantize.to_s.underscore.to_sym) }
  let!(:user) { create(:user) }
    
  describe 'POST #vote_up' do
    context 'authenticated user' do
      before { sign_in user }
      
      it 'creates new vote_up with value == 1 ' do
          expect { post :vote_up, format: :json, params: { id: subject.id } }.to change(subject.votes, :count).by 1

          expect(subject.votes.last.value).to eq 1 
        end
      end

      context 'unaunthenticated user' do
        it 'does not create new vote' do
          expect { post :vote_up, format: :json, params: { id: subject.id } }.to_not change(subject.votes, :count)
        end

        it 'returns unathorized' do
          post :vote_up, format: :json, params: { id: subject.id }
          
          expect(response.code).to eq '401'
        end
      end
    end
  
  # describe '#vote_up' do
  #   it 'creates new vote with 1 value' do
  #     expect { subject.vote_up(user) }.to change(user.votes, :count).by(1)

  #     expect(user.votes.last.value).to eq 1
  #   end
  # end

  # describe '#vote_down' do
  #   it 'creates new vote with -1 value' do
  #     expect { subject.vote_down(user) }.to change(user.votes, :count).by(1)
      
  #     expect(user.votes.last.value).to eq -1
  #   end
  # end

  # describe '#rating' do
  #   let!(:votes) { create_list(:vote, 2, "for_#{described_class}".downcase.to_sym, votable: subject) }

  #   it 'show sum of all votes' do
  #     expect(subject.rating).to eq 2
  #   end
  # end
end

# RSpec.describe QuestionsController, type: :controller do
#   it_behaves_like 'Controller Votable'
# end

# RSpec.describe Answer, type: :model do
#   it_behaves_like 'Votable'
# end
