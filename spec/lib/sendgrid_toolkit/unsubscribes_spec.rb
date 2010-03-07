require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Unsubscribes do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::Unsubscribes.new("fakeuser", "fakepass")
  end
  
  describe "#retrieve" do
    it "returns array of unsubscribed email addresses" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/unsubscribes\.get\.json\?|, :body => '[{"email":"user@domain.com"},{"email":"user2@domain2.com"},{"email":"user3@domain2.com"}]')
      emails = @obj.retrieve
      emails[0]['email'].should == "user@domain.com"
      emails[1]['email'].should == "user2@domain2.com"
      emails[2]['email'].should == "user3@domain2.com"
    end
  end
  describe "#retrieve_with_timestamps" do
    it "parses timestamps" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/unsubscribes\.get\.json\?.*date=1|, :body => '[{"email":"user@domain.com","created":"2010-03-03 11:00:00"},{"email":"user2@domain2.com","created":"2010-03-04 21:00:00"},{"email":"user3@domain2.com","created":"2010-03-05 23:00:00"}]')
      emails = @obj.retrieve_with_timestamps
      0.upto(2) do |index|
        emails[index]['created'].kind_of?(Time).should == true
      end
      emails[0]['created'].asctime.should == "Wed Mar  3 11:00:00 2010"
      emails[1]['created'].asctime.should == "Thu Mar  4 21:00:00 2010"
      emails[2]['created'].asctime.should == "Fri Mar  5 23:00:00 2010"
    end
  end
  
  describe "#add" do
    it "raises no errors on success" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/unsubscribes\.add\.json\?.*email=.+|, :body => '{"message":"success"}')
      lambda {
        @obj.add :email => "user@domain.com"
      }.should_not raise_error
    end
    it "raises error when email already exists" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/unsubscribes\.add\.json\?.*email=.+|, :body => '{"message":"Unsubscribe email address already exists"}')
      lambda {
        @obj.add :email => "user@domain.com"
      }.should raise_error SendgridToolkit::UnsubscribeEmailAlreadyExists
    end
  end
  
  describe "#delete" do
    it "raises no errors on success" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/unsubscribes\.delete\.json\?.*email=.+|, :body => '{"message":"success"}')
      lambda {
        @obj.delete :email => "user@domain.com"
      }.should_not raise_error
    end
    it "raises error when email address does not exist" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/unsubscribes\.delete\.json\?.*email=.+|, :body => '{"message":"Email does not exist"}')
      lambda {
        @obj.delete :email => "user@domain.com"
      }.should raise_error SendgridToolkit::UnsubscribeEmailDoesNotExist
    end
  end
end