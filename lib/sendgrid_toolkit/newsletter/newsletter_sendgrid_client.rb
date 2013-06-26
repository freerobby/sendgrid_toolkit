module SendgridToolkit
  class NewsletterSendgridClient < AbstractSendgridClient

    protected

    def compose_base_path(module_name, action_name)
      "newsletter/#{module_name}/#{action_name}"
    end
  end
end
