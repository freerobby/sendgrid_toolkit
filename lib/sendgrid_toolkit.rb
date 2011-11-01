require 'httparty'

require 'sendgrid_toolkit/abstract_sendgrid_client'
require 'sendgrid_toolkit/common'
require 'sendgrid_toolkit/sendgrid_error'
require 'sendgrid_toolkit/statistics'
require 'sendgrid_toolkit/unsubscribes'
require 'sendgrid_toolkit/spam_reports'
require 'sendgrid_toolkit/bounces'
require 'sendgrid_toolkit/invalid_emails'
require 'sendgrid_toolkit/mail'

module SendgridToolkit
  BASE_URI = "sendgrid.com/api"
end