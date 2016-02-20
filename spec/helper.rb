require 'fakeweb'
require 'sendgrid_toolkit'
require 'rspec'
require 'json'

FakeWeb.allow_net_connect = false

REGEX_ESCAPED_BASE_URI = "api\.sendgrid\.com/api"
REGEX_ESCAPED_BASE_URI_V3 = 'api.sendgrid.com/v3/asm'

def backup_env
  @env_backup = Hash.new
  ENV.keys.each {|key| @env_backup[key] = ENV[key]}
end
def restore_env
  @env_backup.keys.each {|key| ENV[key] = @env_backup[key]}
end
