require File.dirname(__FILE__) + '../../spec_helper'
set :environment, :test

describe "My Traffic light server" do
  include Rack::Test::Methods

  class TrafficLightPiServer < Sinatra::Base
    configure do
      @@line_map = {
        0 => {
          :green => 12,
          :orange => 13,
          :red => 14
        },
        1 => {
          :green => 4,
          :red => 5
        }
      }
      init_lights
    end
  end

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
    last_response.body.should == "14:0"
  end

  it "should get 0 for /1/red" do
    get '/1/red'
    last_response.body.should == "5:0"
  end

  it "should get 0 for /0/green" do
    get '/0/green'
    last_response.body.should == "12:0"
  end

  it "should change color for /0/green" do
    get '/0/green/0'

    get '/0/green'
    last_response.body.should == "12:0"

    get '/0/green/1'
    last_response.body.should == "12:1"

    get '/0/green'
    last_response.body.should == "12:1"

    get '/0/green/0'
    last_response.body.should == "12:0"

    get '/0/green'
    last_response.body.should == "12:0"
  end

  it "should change color for /0/red and keep green status" do
    get '/0/green/0'
    get '/0/red/0'

    get '/0/red'
    last_response.body.should == "14:0"

    get '/0/red/1'
    last_response.body.should == "14:1"

    get '/0/red'
    last_response.body.should == "14:1"

    get '/0/green'
    last_response.body.should == "12:0"
  end

  it "should change color for /1/red and keep /0/red status" do
    get '/0/red/0'
    get '/1/red/0'

    get '/0/red'
    last_response.body.should == "14:0"

    get '/0/red/1'
    last_response.body.should == "14:1"

    get '/0/red'
    last_response.body.should == "14:1"

    get '/1/red'
    last_response.body.should == "5:0"
  end
end
