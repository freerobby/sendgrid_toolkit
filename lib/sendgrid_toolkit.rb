require 'httparty'

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

require 'sendgrid_toolkit/newsletter/newsletter_sendgrid_client'
require 'sendgrid_toolkit/newsletter/lists'
require 'sendgrid_toolkit/newsletter/list_emails'

module SendgridToolkit
  BASE_URI = "api.sendgrid.com/api"

  class << self
    attr_accessor :api_user, :api_key
    attr_writer :base_uri
    def base_uri
      @base_uri || ENV['SENDGRID_API_BASE_URI'] || BASE_URI
    end
  end

end
