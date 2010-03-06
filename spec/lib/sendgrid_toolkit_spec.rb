require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe SendgridToolkit do
  it "loads internal libs" do
    %w(abstract_sendgrid_client unsubscribes).each do |lib|
      lambda {
        require File.expand_path("#{File.dirname(__FILE__)}/../../lib/sendgrid_toolkit/#{lib}")
      }.should_not raise_error
    end
  end
  
  it "loads external libs" do
    %w(httparty).each do |lib|
      lambda {
        require "#{lib}"
      }.should_not raise_error
    end
  end
end