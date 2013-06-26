module SendgridToolkit
  class Lists < NewsletterSendgridClient
    def add(options = {})
      api_post('lists', 'add', options).parsed_response
    end

    def get(options = {})
      api_post('lists', 'get', options).parsed_response
    end

    def edit(options = {})
      api_post('lists', 'edit', options).parsed_response
    end

    def delete(options = {})
      api_post('lists', 'delete', options).parsed_response
    end
  end
end

