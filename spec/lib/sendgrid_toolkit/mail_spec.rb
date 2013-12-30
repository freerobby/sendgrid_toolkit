require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Mail do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::Mail.new("fakeuser", "fakepass")
  end
  
  describe "#send" do
    it "raises error when sendgrid returns an error" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/mail\.send\.json\?|, :body => '{"message": "error", "errors": ["Missing destination email"]}')
      lambda {
        response = @obj.send_mail :from => "testing@fiverr.com", :subject => "Subject", :text => "Text", "x-smtpapi" => {:category => "Testing", :to => ["elad@fiverr.com"]}
      }.should raise_error SendgridToolkit::SendEmailError
    end
  end  
end
