require File.expand_path("#{File.dirname(__FILE__)}/../../../helper")

describe SendgridToolkit::V3::Unsubscribes do
  before do
    FakeWeb.clean_registry
    api_name = ENV['TEST_SMTP_USERNAME'] || 'fakeuser'
    api_key = ENV['TEST_SMTP_PASSWORD'] || 'fakepass'
    @obj = SendgridToolkit::V3::Unsubscribes.new(api_name, api_key)
  end

  describe "#retrieve" do
    xit "returns array of unsubscribed email addresses" do
      FakeWeb.register_uri(:get, "https://#{REGEX_ESCAPED_BASE_URI_V3}/suppressions/user@domain.com", query: {})
      emails = @obj.retrieve(email: 'user@domain.com')

      emails[0]['email'].should == "user@domain.com"
      emails[1]['email'].should == "user2@domain2.com"
      emails[2]['email'].should == "user3@domain2.com"
    end
  end

  describe '#add' do
    xit 'raises no errors on success' do
      FakeWeb.register_uri(:post, "https://#{REGEX_ESCAPED_BASE_URI_V3}/suppressions/global",
                           body: '{"recipient_emails":[{"user@domain.com"}]}')
      -> { @obj.add(recipient_emails: ['user@domain.com']) }.should_not raise_error
    end
    xit 'not raises error when email already exists' do
      FakeWeb.register_uri(:post, "https://#{REGEX_ESCAPED_BASE_URI_V3}/suppressions/global",
                           body: '{"recipient_emails":[{"user@domain.com"}]}')
      -> { @obj.add(recipient_emails: ['user@domain.com']) }.should_not raise_error
    end
  end

  describe '#delete' do
    xit 'raises no errors on success' do
      FakeWeb.register_uri(:delete, "https://#{REGEX_ESCAPED_BASE_URI_V3}/suppressions/user@domain.com",
                           body: '{"message":"success"}')
      -> { @obj.delete email: 'user@domain.com' }.should_not raise_error
    end
    xit 'not raises error when email address does not exist' do
      FakeWeb.register_uri(:delete, "https://#{REGEX_ESCAPED_BASE_URI_V3}/suppressions/user@domain.com",
                           body: '{"message":"success"}')
      -> { @obj.delete email: 'user@domain.com' }.should_not raise_error
    end
  end
end
