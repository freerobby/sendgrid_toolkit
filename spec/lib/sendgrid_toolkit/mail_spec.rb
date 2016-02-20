require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Mail do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::Mail.new("fakeuser", "fakepass")
  end

  describe "#send" do
    it "raises error when sendgrid returns an error" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/mail\.send\.json|, :body => '{"message": "error", "errors": ["Missing destination email"]}')
      lambda {
        response = @obj.send_mail :from => "testing@fiverr.com", :subject => "Subject", :text => "Text", "x-smtpapi" => {:category => "Testing", :to => ["elad@fiverr.com"]}
      }.should raise_error SendgridToolkit::SendEmailError
    end

    it "posts x-smtpapi parameters as json" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/mail\.send\.json|, :body => '{"message":"success"}')
      xsmtpapi = {:category => "Testing", :to => ["scottb@sendgrid.com"]}
      response = @obj.send_mail :to => "scottb@sendgrid.com", :from => "testing@fiverr.com", :subject => "Subject", :text => "Text", "x-smtpapi" => xsmtpapi
      response.request.options[:body]["x-smtpapi"].should == xsmtpapi.to_json
    end
  end
end
