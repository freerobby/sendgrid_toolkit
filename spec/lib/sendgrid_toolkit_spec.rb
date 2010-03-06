require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe SendgridToolkit do
  it "fully loads" do
    %w(subscriptions).each do |lib|
      lambda {
        require File.expand_path("#{File.dirname(__FILE__)}/../../lib/sendgrid_toolkit/#{lib}")
      }.should_not raise_error
    end
  end
end