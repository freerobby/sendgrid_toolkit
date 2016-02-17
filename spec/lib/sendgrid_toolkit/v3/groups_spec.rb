require File.expand_path("#{File.dirname(__FILE__)}/../../../helper")

describe SendgridToolkit::V3::Groups do
  before do
    FakeWeb.clean_registry
    api_name = ENV['TEST_SMTP_USERNAME'] || 'fakeuser'
    api_key = ENV['TEST_SMTP_PASSWORD'] || 'fakepass'
    @obj = SendgridToolkit::V3::Groups.new(api_name, api_key)
  end

  describe "#add" do
    xit 'create group' do
      FakeWeb.register_uri(:post, "https://#{REGEX_ESCAPED_BASE_URI_V3}/groups",
                           body: { name: 'test', description: 'test' })

      group = @obj.add(name: 'test', description: 'test')
      group['name'].should == 'test'
      group['description'].should == 'test'
    end
  end

  describe '#get' do
    xit 'get all groups' do
      FakeWeb.register_uri(:get, "https://#{REGEX_ESCAPED_BASE_URI_V3}/groups", query: {})
      -> { @obj.get }.should_not raise_error
    end
  end

  describe '#delete' do
    xit 'remove group' do
      FakeWeb.register_uri(:get, "https://#{REGEX_ESCAPED_BASE_URI_V3}/groups", query: {})
      group = @obj.get
      group_id = group.first['id']
      FakeWeb.register_uri(:delete, "https://#{REGEX_ESCAPED_BASE_URI_V3}/groups/#{group_id}",
                           body: '{"message":"success"}')
      -> { @obj.delete(group_id: group_id) }.should_not raise_error
    end
  end
end
