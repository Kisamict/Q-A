shared_examples 'API Commentable' do
  let(:comments_count) { comment.commentable.attachments.count }

  it 'answer contains comments' do
    expect(response.body).to have_json_size(comments_count).at_path('comments')
  end

  %w(id body user_id commentable_type commentable_id).each do |attr|
    it "contain #{attr} attribute" do
      expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
    end
  end
end