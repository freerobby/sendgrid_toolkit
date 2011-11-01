require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Mail do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::Mail.new("fakeuser", "fakepass")
  end
  
  describe "#send" do
    it "returns an error when some attributes are missing" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/mail\.send\.json\?|, :body => '[{"email":"user@domain.com"},{"email":"user2@domain2.com"},{"email":"user3@domain2.com"}]')
      emails = @obj.send_mail(:to => "elad@fiverr.com", :from => "testing@fiverr.com", :subject => "Hi there!", :text => "testing body", :x_smtpapi => {:category => "Testing", :to => ["elad@fiverr.com"]})
      emails[0]['email'].should == "user@domain.com"
      emails[1]['email'].should == "user2@domain2.com"
      emails[2]['email'].should == "user3@domain2.com"
    end
  end
  end
end