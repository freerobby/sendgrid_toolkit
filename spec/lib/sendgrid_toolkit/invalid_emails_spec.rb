require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::InvalidEmails do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::InvalidEmails.new("fakeuser", "fakepass")
  end

  describe "#retrieve" do
    it "returns array of invalid emails" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/invalidemails\.get\.json|, :body => '[{"email":"isaac@hotmail.comm","reason":"Mail domain mentioned in email address is unknown"},{"email":"isaac@hotmail","reason":"Bad Syntax"},{"email":"isaac@example.com","reason":"Known bad domain"}]')
      invalid_emails = @obj.retrieve
      invalid_emails[0]['email'].should == "isaac@hotmail.comm"
      invalid_emails[0]['reason'].should == "Mail domain mentioned in email address is unknown"
      invalid_emails[1]['email'].should == "isaac@hotmail"
      invalid_emails[1]['reason'].should == "Bad Syntax"
      invalid_emails[2]['email'].should == "isaac@example.com"
      invalid_emails[2]['reason'].should == "Known bad domain"
    end
  end

  describe "#retrieve_with_timestamps" do
    it "parses timestamps" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/invalidemails\.get\.json|, :body => '[{"email":"isaac@hotmail.comm","reason":"Mail domain mentioned in email address is unknown","created":"2009-06-01 19:41:39"},{"email":"isaac@hotmail","reason":"Bad Syntax","created":"2009-06-12 19:41:39"},{"email":"isaac@example.com","reason":"Known bad domain","created":"2009-06-13 09:40:01"}]')
      invalid_emails = @obj.retrieve_with_timestamps
      0.upto(2) do |index|
        invalid_emails[index]['created'].kind_of?(Time).should == true
      end
      invalid_emails[0]['created'].asctime.should == "Mon Jun  1 19:41:39 2009"
      invalid_emails[1]['created'].asctime.should == "Fri Jun 12 19:41:39 2009"
      invalid_emails[2]['created'].asctime.should == "Sat Jun 13 09:40:01 2009"
    end
  end

  describe "#delete" do
    it "raises no errors on success" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/invalidemails\.delete\.json|, :body => '{"message":"success"}')
      lambda {
        @obj.delete :email => "user@domain.com"
      }.should_not raise_error
    end
    it "raises error when email address does not exist" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/invalidemails\.delete\.json|, :body => '{"message":"Email does not exist"}')
      lambda {
        @obj.delete :email => "user@domain.com"
      }.should raise_error SendgridToolkit::EmailDoesNotExist
    end
  end

end