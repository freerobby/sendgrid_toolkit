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
      blocks[0]['email'].should == "email1@domain.com"
      blocks[0]['status'].should == "5.1.1"
      blocks[0]['reason'].should == "host [127.0.0.1] said: 550 5.1.1 unknown or illegal user: email1@domain.com"
    end
  end

  describe "#retrieve_with_timestamps" do
    it "parses timestamps" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/blocks\.get\.json\?.*date=1|, :body => '[{"email":"email1@domain.com","status":"5.1.1","reason":"host [127.0.0.1] said: 550 5.1.1 unknown or illegal user: email1@domain.com","created":"2009-06-01 19:41:39"},{"email":"email2@domain2.com","status":"5.1.1","reason":"host [127.0.0.1] said: 550 5.1.1 unknown or illegal user: email2@domain2.com","created":"2009-06-12 19:41:39"}]')
      blocks = @obj.retrieve_with_timestamps
      0.upto(1) do |index|
        blocks[index]['created'].kind_of?(Time).should == true
      end
      blocks[0]['created'].asctime.should == "Mon Jun  1 19:41:39 2009"
      blocks[1]['created'].asctime.should == "Fri Jun 12 19:41:39 2009"
    end
  end

  describe "#delete" do
    it "raises no errors on success" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/blocks\.delete\.json\?.*email=.+|, :body => '{"message":"success"}')
      lambda {
        @obj.delete :email => "user@domain.com"
      }.should_not raise_error
    end
    it "raises error when email address does not exist" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/blocks\.delete\.json\?.*email=.+|, :body => '{"message":"Email does not exist"}')
      lambda {
        @obj.delete :email => "user@domain.com"
      }.should raise_error SendgridToolkit::EmailDoesNotExist
    end
    it "does not choke if response does not have a 'message' field" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/blocks\.delete\.json\?.*email=.+|, :body => '{}')
      lambda {
        @obj.delete :email => "user@domain.com"
      }.should_not raise_error
    end
  end

end