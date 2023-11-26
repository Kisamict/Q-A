shared_examples 'API Attachable' do
  let(:attachments_count) { attachment.attachable.attachments.count }

  it 'are included in question object' do
    expect(response.body).to have_json_size(attachments_count).at_path('attachments')
  end

  it 'contains file attribute in link format' do
    expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('attachments/0/url')
  end
end