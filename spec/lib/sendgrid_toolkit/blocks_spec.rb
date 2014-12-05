require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Blocks do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::Blocks.new("fakeuser", "fakepass")
  end

  describe "#retrieve" do
    it "returns array of bounced emails" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/blocks\.get\.json\?|, :body => '[{"email":"email1@domain.com","status":"5.1.1","reason":"host [127.0.0.1] said: 550 5.1.1 unknown or illegal user: email1@domain.com"},{"email":"email2@domain2.com","status":"5.1.1","reason":"host [127.0.0.1] said: 550 5.1.1 unknown or illegal user: email2@domain2.com"}]')
      blocks = @obj.retrieve
      expect(blocks[0]['email']).to eq("email1@domain.com")
      expect(blocks[0]['status']).to eq("5.1.1")
      expect(blocks[0]['reason']).to eq("host [127.0.0.1] said: 550 5.1.1 unknown or illegal user: email1@domain.com")
    end
  end

  describe "#retrieve_with_timestamps" do
    it "parses timestamps" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/blocks\.get\.json\?.*date=1|, :body => '[{"email":"email1@domain.com","status":"5.1.1","reason":"host [127.0.0.1] said: 550 5.1.1 unknown or illegal user: email1@domain.com","created":"2009-06-01 19:41:39"},{"email":"email2@domain2.com","status":"5.1.1","reason":"host [127.0.0.1] said: 550 5.1.1 unknown or illegal user: email2@domain2.com","created":"2009-06-12 19:41:39"}]')
      blocks = @obj.retrieve_with_timestamps
      0.upto(1) do |index|
        expect(blocks[index]['created'].kind_of?(Time)).to be_truthy
      end
      expect(blocks[0]['created'].asctime).to eq("Mon Jun  1 19:41:39 2009")
      expect(blocks[1]['created'].asctime).to eq("Fri Jun 12 19:41:39 2009")
    end
  end

  describe "#delete" do
    it "raises no errors on success" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/blocks\.delete\.json\?.*email=.+|, :body => '{"message":"success"}')
      expect {
        @obj.delete :email => "user@domain.com"
      }.not_to raise_error
    end
    it "raises error when email address does not exist" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/blocks\.delete\.json\?.*email=.+|, :body => '{"message":"Email does not exist"}')
      expect {
        @obj.delete :email => "user@domain.com"
      }.to raise_error SendgridToolkit::EmailDoesNotExist
    end
    it "does not choke if response does not have a 'message' field" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/blocks\.delete\.json\?.*email=.+|, :body => '{}')
      expect {
        @obj.delete :email => "user@domain.com"
      }.not_to raise_error
    end
  end

end
