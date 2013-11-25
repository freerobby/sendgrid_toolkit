require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Common do

  before do
    class FakeClass < SendgridToolkit::AbstractSendgridClient
      include SendgridToolkit::Common
    end
    @fake_class = FakeClass.new
  end

  it "creates a module_name method that returns the class name downcased" do
    @fake_class.module_name.should == "fakeclass"
  end

  it "does not choke if response does not have a 'message' field" do
    FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/fakeclass\.delete\.json\?.*email=.+|, :body => '{}')
    lambda {
      @fake_class.delete :email => "user@domain.com"
    }.should_not raise_error
  end

  # this will only really test it on a computer that's on on utc.
  describe 'retrieve_with_timestamps' do
    it 'should parse the created date in utc' do
      FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/fakeclass\.get\.json\?.*date=1|, :body => '[{"created":"2013-11-25 13:00:00"}]')
      fake_class = @fake_class.retrieve_with_timestamps
      fake_class[0]['created'].utc.iso8601.should == "2013-11-25T13:00:00Z"
    end
  end

end