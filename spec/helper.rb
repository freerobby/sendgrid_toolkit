require 'fakeweb'
require 'sendgrid_toolkit'
require 'rspec'

FakeWeb.allow_net_connect = false

def backup_env
  @env_backup = Hash.new
  ENV.keys.each {|key| @env_backup[key] = ENV[key]}
end
def restore_env
  @env_backup.keys.each {|key| ENV[key] = @env_backup[key]}
end