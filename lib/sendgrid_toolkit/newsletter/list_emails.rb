require 'json'

module SendgridToolkit
  class ListEmails < NewsletterSendgridClient
    def add(options = {})
      if options[:data].kind_of?(Hash)
        options[:data] = options[:data].to_json
      elsif options[:data].kind_of?(Array)
        options[:data] = options[:data].map{|data| data.to_json}
      end

      api_post('email', 'add', options).parsed_response
    end

    def get(options = {})
      api_post('email', 'get', options).parsed_response
    end

    def edit(options = {})
      api_post('email', 'edit', options).parsed_response
    end

    def delete(options = {})
      api_post('email', 'delete', options).parsed_response
    end

    protected

    def compose_base_path(module_name, action_name)
      module_name.prepend 'lists/'

      super
    end
  end
end

