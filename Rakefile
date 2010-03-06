require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('sendgrid_toolkit', '0.0.1') do |p|
  p.description = "Ruby wrapper for sendgrid API"
  p.url = "http://github.com/freerobby/sendgrid_toolkit"
  p.author = "Robby Grossman"
  p.email = "robby@freerobby.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each {|ext| load ext}