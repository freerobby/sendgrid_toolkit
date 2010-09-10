require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

describe SendgridToolkit::Common do

  before do
    class FakeClass
      include SendgridToolkit::Common
    end
    @fake_class = FakeClass.new
  end

  it "creates a module_name method that returns the class name downcased" do
    @fake_class.module_name.should == "fakeclass"
  end

end