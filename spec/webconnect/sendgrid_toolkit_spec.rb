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
      lambda {
        @obj.send(:api_post, "profile", "get", {})
      }.should raise_error SendgridToolkit::AuthenticationFailed
    end
  end

  describe "statistics i/o" do
    before do
      @obj = SendgridToolkit::Statistics.new
    end
    xit "retrieves statistics by day" do
      stats = @obj.retrieve
      stats.count.should > 0
      day_stats = stats.first
      %w(date requests bounces clicks opens spamreports).each do |k|
        day_stats.has_key?(k).should == true
      end
    end
    xit "retrieves aggregate statistics" do
      stats = @obj.retrieve_aggregate
      %w(requests bounces clicks opens spamreports).each do |k|
        stats.has_key?(k).should == true
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
      emails.include?('user@domain.com').should == true
      emails.include?('user2@domain.com').should == true
      @obj.delete :email => 'user@domain.com'
      @obj.delete :email => 'user2@domain.com'
      @obj.retrieve.count.should == 0
    end
  end
end
