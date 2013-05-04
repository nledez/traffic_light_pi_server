require File.dirname(__FILE__) + '../../spec_helper'
set :environment, :test

describe "My Traffic light server" do
  include Rack::Test::Methods

  class TrafficLightPiServer < Sinatra::Base
    configure do
      @@line_map = {
        :front => {
          :green => 12,
          :orange => 13,
          :red => 14
        },
        :left => {
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

  it "should get 0 for /front/red" do
    get '/front/red/0'
    get '/front/red'
    last_response.should be_ok
    last_response.body.should == "14:0"
  end

  it "should get 0 for /left/red" do
    get '/left/red/0'
    get '/left/red'
    last_response.body.should == "5:0"
  end

  it "should get 0 for /front/green" do
    get '/front/green/0'
    get '/front/green'
    last_response.body.should == "12:0"
  end

  it "should change color for /front/green" do
    get '/front/green/0'

    get '/front/green'
    last_response.body.should == "12:0"

    get '/front/green/1'
    last_response.body.should == "12:1"

    get '/front/green'
    last_response.body.should == "12:1"

    get '/front/green/0'
    last_response.body.should == "12:0"

    get '/front/green'
    last_response.body.should == "12:0"
  end

  it "should change color for /front/red and keep green status" do
    get '/front/green/0'
    get '/front/red/0'

    get '/front/red'
    last_response.body.should == "14:0"

    get '/front/red/1'
    last_response.body.should == "14:1"

    get '/front/red'
    last_response.body.should == "14:1"

    get '/front/green'
    last_response.body.should == "12:0"
  end

  it "should change color for /left/red and keep /front/red status" do
    get '/front/red/0'
    get '/left/red/0'

    get '/front/red'
    last_response.body.should == "14:0"

    get '/front/red/1'
    last_response.body.should == "14:1"

    get '/front/red'
    last_response.body.should == "14:1"

    get '/left/red'
    last_response.body.should == "5:0"
  end
end
