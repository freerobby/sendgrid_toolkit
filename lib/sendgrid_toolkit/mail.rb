module SendgridToolkit
  class Mail < AbstractSendgridClient
    def send(options = {})
      options.assert_valid_keys :to, :x_smtpapi, :subject, :from, :text, :html, :reply_to, :from_name, :to_name, :date, :headers
      response = api_post('mail', 'send', options)
      raise(SendEmailError, "SendMail API refused to send email: #{response["errors"].to_sentence}") if response["message"] = "error"
    end
  end
end