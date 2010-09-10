module SendgridToolkit

  class InvalidEmails < AbstractSendgridClient

    def retrieve(options = {})
      response = api_post('invalidemails', 'get', options)
      response
    end

    def retrieve_with_timestamps(options = {})
      options.merge! :date => 1
      response = retrieve options
      response.each do |unsubscribe|
        unsubscribe['created'] = Time.parse(unsubscribe['created']) if unsubscribe.has_key?('created')
      end
      response
    end

    def delete(options = {})
      response = api_post('invalidemails', 'delete', options)
      raise InvalidEmailDoesNotExist if response['message'].include?('does not exist')
      response
    end

  end

end