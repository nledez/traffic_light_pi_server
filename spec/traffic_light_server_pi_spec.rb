require File.dirname(__FILE__) + '/spec_helper'
set :environment, :test

describe "My Traffic light server" do
  include Rack::Test::Methods

  def app
    @app || TrafficLightPiServer
  end

  # Do a root test
  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end

  it "should get 0 for /0/red" do
    get '/0/red'
    last_response.should be_ok
    last_response.body.should == "0"
  end
end
