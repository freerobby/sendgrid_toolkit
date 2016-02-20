require 'json'

module SendgridToolkit
  class Mail < AbstractSendgridClient
    def send_mail(options = {})
      response = api_post('mail', 'send', convert_params(options))
      raise(SendEmailError, "SendMail API refused to send email: #{response["errors"].inspect}") if response["message"] == "error"
      response
    end

    private
    def convert_params(options)
    	options["x-smtpapi"] = options["x-smtpapi"].to_json if options.has_key?("x-smtpapi")
    	options
    end
  end
end
