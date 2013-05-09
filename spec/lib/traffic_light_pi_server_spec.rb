require File.dirname(__FILE__) + '../../spec_helper'
set :environment, :test

describe "My Traffic light server" do
  include Rack::Test::Methods

  class TrafficLightPiServer < Sinatra::Base
    @@mp3player = "#{File.dirname(__FILE__)}/../mpg123-mock"
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

  it "should change status for different line & light" do
    get '/front/green/0'
    get '/front/red/0'
    get '/left/red/0'

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

    get '/front/red'
    last_response.body.should == "14:0"

    get '/front/red/1'
    last_response.body.should == "14:1"

    get '/front/red'
    last_response.body.should == "14:1"

    get '/front/green'
    last_response.body.should == "12:0"

    get '/left/red'
    last_response.body.should == "5:0"
  end

  it "should play mp3" do
    get '/play/clic'
    last_response.should be_ok
    last_response.body.should =~ /Played with pid: \d+/
  end

  it "should return 404 if try to play a missing file" do
    get '/play/missing-file'
    last_response.status.should == 404
  end

  it "should return a custom 404 & 500 error pages" do
    get '/left/red/bad/url'
    last_response.status.should == 404
    last_response.body.should =~ /traffic-lights-lost/

    get '/left/red/4'
    last_response.status.should == 500
    last_response.body.should =~ /traffic-lights-ko/
  end
end
