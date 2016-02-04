module SendgridToolkit
  module V3
    class Groups < SendgridToolkit::V3::AbstractSendgridClient
      def add(options = {})
        response = api_post('groups', options)
        fail GroupsError if response.is_a?(Hash) && response.key?('errors')
        response
      end

      def get(group_id = nil)
        action_name = 'groups' + (group_id ? "/#{group_id}" : '')
        response = api_get(action_name)
        fail GroupsError if response.is_a?(Hash) && response.key?('errors')
        response
      end

      def delete(options = {})
        fail NoGroupIdSpecified unless options[:group_id]

        response = api_delete("groups/#{options[:group_id]}")
        fail GroupsError if response.is_a?(Hash) && response.key?('errors')
        response
      end
    end
  end
end
