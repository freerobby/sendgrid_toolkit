module SendgridToolkit
  class Mail < AbstractSendgridClient
    def send_mail(options = {})
      options.assert_valid_keys :to, :api_headers, :subject, :from, :text, :html, :reply_to, :from_name, :to_name, :date, :headers
      options["X-SMTPAPI"] = options[:api_headers]
      response = api_post('mail', 'send', options)
      raise(SendEmailError, "SendMail API refused to send email: #{response["errors"].inspect}") if response["message"] == "error"
      true
    end
  end
end