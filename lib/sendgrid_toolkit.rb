require 'httparty'

require '/home/rishi/work/github/my/sendgrid_toolkit/lib/sendgrid_toolkit/abstract_sendgrid_client'
require '/home/rishi/work/github/my/sendgrid_toolkit/lib/sendgrid_toolkit/common'
require '/home/rishi/work/github/my/sendgrid_toolkit/lib/sendgrid_toolkit/sendgrid_error'
require '/home/rishi/work/github/my/sendgrid_toolkit/lib/sendgrid_toolkit/statistics'
require '/home/rishi/work/github/my/sendgrid_toolkit/lib/sendgrid_toolkit/unsubscribes'
require '/home/rishi/work/github/my/sendgrid_toolkit/lib/sendgrid_toolkit/spam_reports'
require '/home/rishi/work/github/my/sendgrid_toolkit/lib/sendgrid_toolkit/bounces'
require '/home/rishi/work/github/my/sendgrid_toolkit/lib/sendgrid_toolkit/blocks'
require '/home/rishi/work/github/my/sendgrid_toolkit/lib/sendgrid_toolkit/invalid_emails'
require '/home/rishi/work/github/my/sendgrid_toolkit/lib/sendgrid_toolkit/mail'
require '/home/rishi/work/github/my/sendgrid_toolkit/lib/sendgrid_toolkit/category'
require '/home/rishi/work/github/my/sendgrid_toolkit/lib/sendgrid_toolkit/recipients'

module SendgridToolkit
  BASE_URI = "sendgrid.com/api"
  BASE_URI_FOR_MARKETING = "sendgrid.com/api/newsletter"
  
  class << self
    def api_user=(v); @api_user = v; end
    def api_user; @api_user; end
    
    def api_key=(v); @api_key = v; end
    def api_key; @api_key; end
  end
  
end
