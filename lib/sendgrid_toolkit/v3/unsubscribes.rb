module SendgridToolkit
  module V3
    class Unsubscribes < SendgridToolkit::V3::AbstractSendgridClient
      def add(options = {})
        fail NoGroupIdSpecified unless options[:group_id]

        response = api_post("groups/#{options[:group_id]}/suppressions", options)
        fail APIError if response.is_a?(Hash) && response.key?('errors')
        response
      end

      def delete(options = {})
        fail NoGroupIdSpecified unless options[:group_id]

        response = api_delete("groups/#{options[:group_id]}/suppressions/#{options[:email]}", options)
        fail APIError if response.is_a?(Hash) && response.key?('errors')
        response
      end

      def retrieve(options = {})
        fail NoGroupIdSpecified unless options[:group_id]

        response = api_get("groups/#{options[:group_id]}/suppressions", options)
        response
      end
    end
  end
end
