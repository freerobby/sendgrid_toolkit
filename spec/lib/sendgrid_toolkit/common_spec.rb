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
    FakeWeb.register_uri(:post, %r|https://sendgrid\.com/api/fakeclass\.delete\.json\?.*email=.+|, :body => 'An internal server error occurred. Please try again later.')
    lambda {
      @fake_class.delete :email => "user@domain.com"
    }.should_not raise_error
  end

end