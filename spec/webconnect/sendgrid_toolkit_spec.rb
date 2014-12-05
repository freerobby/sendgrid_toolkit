require File.expand_path("#{File.dirname(__FILE__)}/../helper")

FakeWeb.allow_net_connect = true

describe SendgridToolkit do
  before :all do
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = true
  end
  after :all do
    FakeWeb.allow_net_connect = false
  end

  before do
    backup_env

    # Don't let SendgridToolkit fall back to SMTP_USERNAME and SMTP_PASSWORD
    ENV['SMTP_USERNAME'] = ENV['TEST_SMTP_USERNAME'] || "fakeuser"
    ENV['SMTP_PASSWORD'] = ENV['TEST_SMTP_PASSWORD'] || "fakepass"
  end

  after do
    restore_env
  end

  describe "abstract_sendgrid_client i/o" do
    xit "throws authentication error when authentication fails" do
      @obj = SendgridToolkit::AbstractSendgridClient.new("fakeuser", "fakepass")
      expect {
        @obj.send(:api_post, "profile", "get", {})
      }.to raise_error SendgridToolkit::AuthenticationFailed
    end
  end

  describe "statistics i/o" do
    before do
      @obj = SendgridToolkit::Statistics.new
    end
    xit "retrieves statistics by day" do
      stats = @obj.retrieve
      expect(stats.count).to be > 0
      day_stats = stats.first
      %w(date requests bounces clicks opens spamreports).each do |k|
        expect(day_stats.has_key?(k)).to be_truthy
      end
    end
    xit "retrieves aggregate statistics" do
      stats = @obj.retrieve_aggregate
      %w(requests bounces clicks opens spamreports).each do |k|
        expect(stats.has_key?(k)).to be_truthy
      end
    end
  end

  describe "unsubscribes i/o" do
    before do
      @obj = SendgridToolkit::Unsubscribes.new
      unsubscribes = @obj.retrieve
      unsubscribes.each do |u|
        @obj.delete :email => u['email']
      end
    end
    xit "adds, retrieves and deletes email addresses properly" do
      @obj.add :email => "user@domain.com"
      @obj.add :email => "user2@domain.com"
      unsubs = @obj.retrieve_with_timestamps
      emails = unsubs.map {|h| h['email']}
      expect(emails.include?('user@domain.com')).to be_truthy
      expect(emails.include?('user2@domain.com')).to be_truthy
      @obj.delete :email => 'user@domain.com'
      @obj.delete :email => 'user2@domain.com'
      expect(@obj.retrieve.count).to eq(0)
    end
  end
end
