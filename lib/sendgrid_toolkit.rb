require 'faraday'
require 'faraday_middleware'

require 'sendgrid_toolkit/abstract_sendgrid_client'
require 'sendgrid_toolkit/common'
require 'sendgrid_toolkit/sendgrid_error'
require 'sendgrid_toolkit/statistics'
require 'sendgrid_toolkit/unsubscribes'
require 'sendgrid_toolkit/spam_reports'
require 'sendgrid_toolkit/bounces'
require 'sendgrid_toolkit/blocks'
require 'sendgrid_toolkit/invalid_emails'
require 'sendgrid_toolkit/mail'

module SendgridToolkit
  BASE_URI = "sendgrid.com/api"
  
  class << self
    def api_user=(v); @api_user = v; end
    def api_user; @api_user; end
    
    def api_key=(v); @api_key = v; end
    def api_key; @api_key; end
  end
  
end