require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Statistics do
  before do
    FakeWeb.clean_registry
    @obj = SendgridToolkit::Statistics.new("fakeuser", "fakepass")
  end

  describe "#retrieve" do
    it "parses daily totals" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/stats\.get\.json|, :body => '[{"date":"2009-06-20","requests":12342,"bounces":12,"clicks":10223,"opens":9992,"spamreports":5},{"date":"2009-06-21","requests":32342,"bounces":10,"clicks":14323,"opens":10995,"spamreports":7},{"date":"2009-06-22","requests":52342,"bounces":11,"clicks":19223,"opens":12992,"spamreports":2}]')
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
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/stats\.get\.json|, :body => '{"requests":12342,"bounces":12,"clicks":10223,"opens":9992,"spamreports":5}')
      stats = @obj.retrieve_aggregate
      %w(bounces clicks delivered invalid_email opens repeat_bounces repeat_spamreports repeat_unsubscribes requests spamreports unsubscribes).each do |int|
        stats[int].kind_of?(Integer).should == true if stats.has_key?(int) # We support all fields presently returned, but we are only testing what sendgrid officially documents
      end
    end

    it "parses aggregate statistics for array response" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/stats\.get\.json|, :body => '[{"requests":12342,"bounces":12,"clicks":10223,"opens":9992,"spamreports":5},{"requests":5,"bounces":10,"clicks":10223,"opens":9992,"spamreports":5}]')
      stats = @obj.retrieve_aggregate
      %w(bounces clicks delivered invalid_email opens repeat_bounces repeat_spamreports repeat_unsubscribes requests spamreports unsubscribes).each do |int|
        # We support all fields presently returned, but we are only testing what sendgrid officially documents
        stats[0][int].kind_of?(Integer).should == true if stats[0].has_key?(int)
        stats[1][int].kind_of?(Integer).should == true if stats[1].has_key?(int)
      end
    end
  end

  describe "#list_categories" do
    it "parses categories list" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/stats\.get\.json|, :body => '[{"category":"categoryA"},{"category":"categoryB"},{"category":"categoryC"}]')
      cats = @obj.list_categories
      cats[0]['category'].should == 'categoryA'
      cats[1]['category'].should == 'categoryB'
      cats[2]['category'].should == 'categoryC'
    end
  end

  describe "#advanced" do
    it "parses browser totals" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/stats\.getAdvanced\.json|, :body => '[{"date":"2014-01-21","delivered":{"Chrome":1},"request":{"Chrome":1},"processed":{"Chrome":1}},{"date":"2014-01-22","delivered":{"Chrome":1},"request":{"Chrome":1},"processed":{"Chrome":1}}]')
      stats = @obj.advanced('browsers', Date.new)
      stats.each do |stat|
        %w(delivered processed request).each do |type|
          stat[type].kind_of?(Hash).should == true if stat.has_key?(type)
        end
        stat['date'].kind_of?(Date).should == true
      end
    end

    it "parses client totals" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/stats\.getAdvanced\.json|, :body => '[{"date":"2014-01-21","delivered":{"Gmail":1},"request":{"Gmail":1},"processed":{"Gmail":1}},{"date":"2014-01-22","delivered":{"Gmail":1},"request":{"Gmail":1},"processed":{"Gmail":1}}]')
      stats = @obj.advanced('clients', Date.new)
      stats.each do |stat|
        %w(delivered processed request).each do |type|
          stat[type].kind_of?(Hash).should == true if stat.has_key?(type)
        end
        stat['date'].kind_of?(Date).should == true
      end
    end

    it "parses device totals" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/stats\.getAdvanced\.json|, :body => '[{"date":"2014-01-21","delivered":{"Webmail":1},"request":{"Webmail":1},"processed":{"Webmail":1}},{"date":"2014-01-22","delivered":{"Webmail":1},"request":{"Webmail":1},"processed":{"Webmail":1}}]')
      stats = @obj.advanced('devices', Date.new)
      stats.each do |stat|
        %w(delivered processed request).each do |type|
          stat[type].kind_of?(Hash).should == true if stat.has_key?(type)
        end
        stat['date'].kind_of?(Date).should == true
      end
    end

    it "parses geo totals" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/stats\.getAdvanced\.json|, :body => '[{"date":"2014-01-21","delivered":{"US":1},"request":{"US":1},"processed":{"US":1}},{"date":"2014-01-22","delivered":{"US":1},"request":{"US":1},"processed":{"US":1}}]')
      stats = @obj.advanced('geo', Date.new)
      stats.each do |stat|
        %w(delivered processed request).each do |type|
          stat[type].kind_of?(Hash).should == true if stat.has_key?(type)
        end
        stat['date'].kind_of?(Date).should == true
      end
    end

    it "parses global totals" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/stats\.getAdvanced\.json|, :body => '[{"delivered":41,"request":41,"unique_open":1,"unique_click":1,"processed":41,"date":"2013-01-01","open":2,"click":1},{"delivered":224,"unique_open":1,"request":224,"processed":224,"date":"2013-01-02","open":3}]')
      stats = @obj.advanced('global', Date.new)
      stats.each do |stat|
        %w(click delivered open processed request unique_click unique_open).each do |type|
          stat[type].kind_of?(Integer).should == true if stat.has_key?(type)
        end
        stat['date'].kind_of?(Date).should == true
      end
    end

    it "parses ISP totals" do
      FakeWeb.register_uri(:post, %r|https://#{REGEX_ESCAPED_BASE_URI}/stats\.getAdvanced\.json|, :body => '[{"date":"2014-01-21","delivered":{"Gmail":1},"request":{"Gmail":1},"processed":{"Gmail":1}},{"date":"2014-01-22","delivered":{"Gmail":1},"request":{"Gmail":1},"processed":{"Gmail":1}}]')
      stats = @obj.advanced('isps', Date.new)
      stats.each do |stat|
        %w(delivered processed request).each do |type|
          stat[type].kind_of?(Hash).should == true if stat.has_key?(type)
        end
        stat['date'].kind_of?(Date).should == true
      end
    end
  end
end