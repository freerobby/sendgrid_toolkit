$LOAD_PATH.unshift(File.expand_path("#{File.dirname(__FILE__)}/../lib"))

require 'fakeweb'
require 'sendgrid_toolkit'
require 'spec'

FakeWeb.allow_net_connect = false