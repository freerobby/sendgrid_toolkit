require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Statistics do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::Statistics.new("fakeuser", "fakepass")
  end
  
  describe "#retrieve" do
    it "parses daily totals" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/stats\.get\.json\?|, :body => '[{"date":"2009-06-20","requests":12342,"bounces":12,"clicks":10223,"opens":9992,"spamreports":5},{"date":"2009-06-21","requests":32342,"bounces":10,"clicks":14323,"opens":10995,"spamreports":7},{"date":"2009-06-22","requests":52342,"bounces":11,"clicks":19223,"opens":12992,"spamreports":2}]')
      stats = @obj.retrieve
      stats.each do |stat|
        %w(bounces clicks delivered invalid_email opens repeat_bounces repeat_spamreports repeat_unsubscribes requests spamreports unsubscribes).each do |int|
          stat[int].kind_of?(Integer).should == true if stat.has_key?(int) # We support all fields presently returned, but we are only testing what sendgrid officially documents
        end
        stat['date'].kind_of?(Date).should == true
      end
    end
  end
  
  describe "#retrieve_aggregate" do
    it "parses aggregate statistics" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/stats\.get\.json\?.*aggregate=1|, :body => '{"requests":12342,"bounces":12,"clicks":10223,"opens":9992,"spamreports":5}')
      stats = @obj.retrieve_aggregate
      %w(bounces clicks delivered invalid_email opens repeat_bounces repeat_spamreports repeat_unsubscribes requests spamreports unsubscribes).each do |int|
        stats[int].kind_of?(Integer).should == true if stats.has_key?(int) # We support all fields presently returned, but we are only testing what sendgrid officially documents
      end
    end
  end
  
  describe "#list_categories" do
    it "parses categories list" do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/stats\.get\.json\?.*list=true|, :body => '[{"category":"categoryA"},{"category":"categoryB"},{"category":"categoryC"}]')
      cats = @obj.list_categories
      cats[0]['category'].should == 'categoryA'
      cats[1]['category'].should == 'categoryB'
      cats[2]['category'].should == 'categoryC'
    end
  end
end