require File.expand_path("#{File.dirname(__FILE__)}/../../../helper")

describe SendgridToolkit::V3::AbstractSendgridClient do
  before do
    backup_env
  end
  after do
    restore_env
  end

  describe '#api_post' do
    it "throws error when authentication fails" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI_V3}/profile\.get\.json\?|, :body => '{"error":{"code":401,"message":"Permission denied, wrong credentials"}}')
      @obj = SendgridToolkit::AbstractSendgridClient.new("fakeuser", "fakepass")
      lambda {
        @obj.send(:api_post, "profile", "get", {})
      }.should raise_error SendgridToolkit::AuthenticationFailed
    end
    it "thows error when sendgrid response is a server error" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI_V3}/profile\.get\.json\?|, :body => '{}', :status => ['500', 'Internal Server Error'])
      @obj = SendgridToolkit::AbstractSendgridClient.new("someuser", "somepass")
      lambda {
        @obj.send(:api_post, "profile", "get", {})
      }.should raise_error SendgridToolkit::AuthenticationFailed
    end
    it "handles unexpected error responses gracefully" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/profile\.get\.json|, :body => '<html>Html formatted error</html>', :status => ['500', 'Internal Server Error'])
      @obj = SendgridToolkit::AbstractSendgridClient.new("someuser", "somepass")
      lambda {
        @obj.send(:api_post, "profile", "get", {})
      }.should raise_error SendgridToolkit::SendgridServerError, /<html>Html formatted error<\/html> - SendgridToolkit warning/
    end
    it "thows error when sendgrid response is an API error" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI_V3}/stats\.get\.json\?|, :body => '{"error": "error in end_date: end date is in the future"}', :status => ['400', 'Bad Request'])
      @obj = SendgridToolkit::AbstractSendgridClient.new("someuser", "somepass")
      lambda {
        @obj.send(:api_post, "stats", "get", {})
      }.should raise_error SendgridToolkit::SendgridServerError
    end
  end

  describe "#initialize" do
    after(:each) do
      SendgridToolkit.api_user = nil
      SendgridToolkit.api_key = nil
    end
    it 'stores api credentials when passed in' do
      ENV['SMTP_USERNAME'] = 'env_username'
      ENV['SMTP_PASSWORD'] = 'env_apikey'

      @obj = SendgridToolkit::V3::AbstractSendgridClient.new('username', 'apikey')
      @obj.instance_variable_get('@api_user').should == 'username'
      @obj.instance_variable_get('@api_key').should == 'apikey'
    end
    it 'uses module level user and key if they are set' do
      SendgridToolkit.api_user = 'username'
      SendgridToolkit.api_key = 'apikey'

      SendgridToolkit.api_key.should == 'apikey'
      SendgridToolkit.api_user.should == 'username'

      @obj = SendgridToolkit::V3::AbstractSendgridClient.new
      @obj.instance_variable_get('@api_user').should == 'username'
      @obj.instance_variable_get('@api_key').should == 'apikey'
    end
    it 'resorts to environment variables when no credentials specified' do
      ENV['SMTP_USERNAME'] = 'env_username'
      ENV['SMTP_PASSWORD'] = 'env_apikey'

      @obj = SendgridToolkit::V3::AbstractSendgridClient.new()
      @obj.instance_variable_get('@api_user').should == 'env_username'
      @obj.instance_variable_get('@api_key').should == 'env_apikey'
    end
    it 'throws error when no credentials are found' do
      ENV['SMTP_USERNAME'] = nil
      ENV['SMTP_PASSWORD'] = nil

      lambda {
        @obj = SendgridToolkit::V3::AbstractSendgridClient.new()
      }.should raise_error SendgridToolkit::NoAPIUserSpecified

      lambda {
        @obj = SendgridToolkit::V3::AbstractSendgridClient.new(nil, 'password')
      }.should raise_error SendgridToolkit::NoAPIUserSpecified

      lambda {
        @obj = SendgridToolkit::V3::AbstractSendgridClient.new('user', nil)
      }.should raise_error SendgridToolkit::NoAPIKeySpecified
    end
  end
end
