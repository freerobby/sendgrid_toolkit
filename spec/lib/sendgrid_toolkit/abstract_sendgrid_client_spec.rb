require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::AbstractSendgridClient do
  before do
    backup_env
  end
  after do
    restore_env
  end
  
  describe "#initialize" do
    it "stores api credentials when passed in" do
      ENV['SMTP_USERNAME'] = "env_username"
      ENV['SMTP_PASSWORD'] = "env_apikey"
      
      @obj = SendgridToolkit::AbstractSendgridClient.new("username", "apikey")
      @obj.instance_variable_get("@api_user").should == "username"
      @obj.instance_variable_get("@api_key").should == "apikey"
    end
    it "resorts to environment variables when no credentials specified" do
      ENV['SMTP_USERNAME'] = "env_username"
      ENV['SMTP_PASSWORD'] = "env_apikey"
      
      @obj = SendgridToolkit::AbstractSendgridClient.new()
      @obj.instance_variable_get("@api_user").should == "env_username"
      @obj.instance_variable_get("@api_key").should == "env_apikey"
    end
    it "throws error when no credentials are found" do
      ENV['SMTP_USERNAME'] = nil
      ENV['SMTP_PASSWORD'] = nil
      
      lambda {
        @obj = SendgridToolkit::AbstractSendgridClient.new()
      }.should raise_error SendgridToolkit::NoAPIUserSpecified
      
      lambda {
        @obj = SendgridToolkit::AbstractSendgridClient.new(nil, "password")
      }.should raise_error SendgridToolkit::NoAPIUserSpecified
      
      lambda {
        @obj = SendgridToolkit::AbstractSendgridClient.new("user", nil)
      }.should raise_error SendgridToolkit::NoAPIKeySpecified
    end
  end
end