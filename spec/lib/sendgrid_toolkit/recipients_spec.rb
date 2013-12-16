require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Recipients do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::Recipients.new("fakeuser", "fakepass")
  end
  
  describe "#send" do
    
    it "raises error when sendgrid returns authentication error" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/newsletter/recipients/get\.json\?|, :status => ['403'])
      lambda {
        response = @obj.retrieve
      }.should raise_error SendgridToolkit::AuthenticationFailed
    end
    
    it "raises error when sendgrid returns an error" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/newsletter/recipients/get\.json\?|, :status => ['404'])
      lambda {
        response = @obj.retrieve
      }.should raise_error SendgridToolkit::SendgridServerError
    end
    
    it "returns response when no error is recieved" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/newsletter/recipients/get\.json\?|, :body => "[{\"list\": \"test_list_1_by_rishi\"}]")
      response = @obj.retrieve
      response.should == [{"list" => "test_list_1_by_rishi"}]
    end

  end  
end
