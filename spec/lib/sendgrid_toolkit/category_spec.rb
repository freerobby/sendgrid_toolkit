require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Category do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::Category.new("fakeuser", "fakepass")
  end
  
  describe "#send" do
    
    it "raises error when sendgrid returns authentication error" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/newsletter/category/list\.json\?|, :status => ['403'])
      lambda {
        response = @obj.retrieve({}, 'list')
      }.should raise_error SendgridToolkit::AuthenticationFailed
    end
    
    it "raises error when sendgrid returns an error" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/newsletter/category/list\.json\?|, :status => ['404'])
      lambda {
        response = @obj.retrieve({}, 'list')
      }.should raise_error SendgridToolkit::SendgridServerError
    end
    
    it "returns response when no error is recieved" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/newsletter/category/list\.json\?|, :body => "[]")
      response = @obj.retrieve({}, 'list') 
      response.should == []
    end

  end  
end
