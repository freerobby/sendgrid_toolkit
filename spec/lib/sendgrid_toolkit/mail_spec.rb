require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Mail do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::Mail.new("fakeuser", "fakepass")
  end

  subject { SendgridToolkit::Mail.new("fakeuser", "fakepass") }
  
  describe "#send" do
    it "raises error when sendgrid returns an error" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/mail\.send\.json\?|, :body => '{"message": "error", "errors": ["Missing destination email"]}')
      lambda {
        response = @obj.send_mail :from => "testing@fiverr.com", :subject => "Subject", :text => "Text", "x-smtpapi" => {:category => "Testing", :to => ["elad@fiverr.com"]}
      }.should raise_error SendgridToolkit::SendEmailError
    end
    it 'accepts a post body' do
      options = { :from => "testing@fiverr.com",
        :subject => "Subject",
        :text => "Text",
        "x-smtpapi" => {:category => "Testing", :to => ["email@email.com"] }
      }
      body = {
        :html => "<html><head></head><body>Test</body></html>"
      }
      subject.should_receive(:api_post).with('mail', 'send', options, body).and_return({})
      subject.send_mail(options, body)
    end
  end  
end
