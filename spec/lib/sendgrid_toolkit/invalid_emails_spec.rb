require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::InvalidEmails do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::InvalidEmails.new("fakeuser", "fakepass")
  end

  describe "#retrieve" do
    it "returns array of invalid emails" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/invalidemails\.get\.json\?|, :body => '[{"email":"isaac@hotmail.comm","reason":"Mail domain mentioned in email address is unknown"},{"email":"isaac@hotmail","reason":"Bad Syntax"},{"email":"isaac@example.com","reason":"Known bad domain"}]')
      invalid_emails = @obj.retrieve
      expect(invalid_emails[0]['email']).to eq("isaac@hotmail.comm")
      expect(invalid_emails[0]['reason']).to eq("Mail domain mentioned in email address is unknown")
      expect(invalid_emails[1]['email']).to eq("isaac@hotmail")
      expect(invalid_emails[1]['reason']).to eq("Bad Syntax")
      expect(invalid_emails[2]['email']).to eq("isaac@example.com")
      expect(invalid_emails[2]['reason']).to eq("Known bad domain")
    end
  end

  describe "#retrieve_with_timestamps" do
    it "parses timestamps" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/invalidemails\.get\.json\?.*date=1|, :body => '[{"email":"isaac@hotmail.comm","reason":"Mail domain mentioned in email address is unknown","created":"2009-06-01 19:41:39"},{"email":"isaac@hotmail","reason":"Bad Syntax","created":"2009-06-12 19:41:39"},{"email":"isaac@example.com","reason":"Known bad domain","created":"2009-06-13 09:40:01"}]')
      invalid_emails = @obj.retrieve_with_timestamps
      0.upto(2) do |index|
        expect(invalid_emails[index]['created'].kind_of?(Time)).to be_truthy
      end
      expect(invalid_emails[0]['created'].asctime).to eq("Mon Jun  1 19:41:39 2009")
      expect(invalid_emails[1]['created'].asctime).to eq("Fri Jun 12 19:41:39 2009")
      expect(invalid_emails[2]['created'].asctime).to eq("Sat Jun 13 09:40:01 2009")
    end
  end

  describe "#delete" do
    it "raises no errors on success" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/invalidemails\.delete\.json\?.*email=.+|, :body => '{"message":"success"}')
      expect {
        @obj.delete :email => "user@domain.com"
      }.not_to raise_error
    end
    it "raises error when email address does not exist" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/invalidemails\.delete\.json\?.*email=.+|, :body => '{"message":"Email does not exist"}')
      expect {
        @obj.delete :email => "user@domain.com"
      }.to raise_error SendgridToolkit::EmailDoesNotExist
    end
  end

end
