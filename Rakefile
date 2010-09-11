require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "sendgrid_toolkit"
    gemspec.summary = "A Ruby wrapper and utility library for communicating with the Sendgrid API"
    gemspec.description = "A Ruby wrapper and utility library for communicating with the Sendgrid API"
    gemspec.email = "robby@freerobby.com"
    gemspec.homepage = "http://github.com/freerobby/sendgrid_toolkit"
    gemspec.authors = ["Robby Grossman"]
    
    gemspec.add_dependency "httparty"
    # Development dependencies: fakeweb, rake, jeweler, rspec
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler must be installed. Use 'sudo gem install jeweler'."
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each {|ext| load ext}