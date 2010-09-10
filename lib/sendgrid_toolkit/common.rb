module SendgridToolkit

  module Common

    def retrieve(options = {})
      response = api_post(module_name, 'get', options)
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
      response = api_post(module_name, 'delete', options)
      raise EmailDoesNotExist if response['message'].include?('does not exist')
      response
    end

    def module_name
      self.class.to_s.split("::").last.downcase
    end

  end

end