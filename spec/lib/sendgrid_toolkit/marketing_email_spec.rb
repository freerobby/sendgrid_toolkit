require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::MarketingEmail do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::MarketingEmail.new("fakeuser", "fakepass")
  end
  
  describe "#send" do
    
    it "raises error when sendgrid returns authentication error" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/newsletter/list\.json\?|, :status => ['403'])
      lambda {
        response = @obj.index 
      }.should raise_error SendgridToolkit::AuthenticationFailed
    end
    
    it "raises error when sendgrid returns an error" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/newsletter/list\.json\?|, :status => ['404'])
      lambda {
        response = @obj.index 
      }.should raise_error SendgridToolkit::SendgridServerError
    end

  end  
end
