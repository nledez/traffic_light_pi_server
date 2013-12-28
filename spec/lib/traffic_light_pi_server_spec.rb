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
    post '/reset'

    get '/lines'
    last_response.body.should == "{\"front\":{\"green\":1,\"orange\":0,\"red\":0},\"left\":{\"green\":1,\"red\":0}}"

    get '/front/green'
    last_response.body.should == "1"

    post '/front/green/1'
    last_response.body.should == "1"

    get '/front/green'
    last_response.body.should == "1"

    post '/front/green/0'
    last_response.body.should == "0"

    get '/front/green'
    last_response.body.should == "0"

    get '/front/red'
    last_response.body.should == "0"

    post '/front/red/1'
    last_response.body.should == "1"

    get '/front/red'
    last_response.body.should == "1"

    get '/front/green'
    last_response.body.should == "0"

    get '/left/red'
    last_response.body.should == "0"
  end

  it "should reset lights" do
    post '/reset'
    last_response.body.should == "{\"front\":{\"green\":1,\"orange\":0,\"red\":0},\"left\":{\"green\":1,\"red\":0}}"

    get '/lines'
    last_response.body.should == "{\"front\":{\"green\":1,\"orange\":0,\"red\":0},\"left\":{\"green\":1,\"red\":0}}"

    post '/front/green/0'
    post '/front/red/1'
    post '/left/red/1'

    get '/lines'
    last_response.body.should == "{\"front\":{\"green\":0,\"orange\":0,\"red\":1},\"left\":{\"green\":1,\"red\":1}}"

    post '/front/reset'
    last_response.body.should == "{\"green\":1,\"orange\":0,\"red\":0}"

    get '/lines'
    last_response.body.should == "{\"front\":{\"green\":1,\"orange\":0,\"red\":0},\"left\":{\"green\":1,\"red\":1}}"

    post '/left/reset'
    last_response.body.should == "{\"green\":1,\"red\":0}"

    get '/lines'
    last_response.body.should == "{\"front\":{\"green\":1,\"orange\":0,\"red\":0},\"left\":{\"green\":1,\"red\":0}}"
  end

  it "should reset lights" do
    post '/reset'

    get '/lines'
    last_response.body.should == "{\"front\":{\"green\":1,\"orange\":0,\"red\":0},\"left\":{\"green\":1,\"red\":0}}"

    post '/front/green/0'
    post '/front/orange/1'
    post '/left/red/1'

    get '/lines'
    last_response.body.should == "{\"front\":{\"green\":0,\"orange\":1,\"red\":0},\"left\":{\"green\":1,\"red\":1}}"

    post '/reset'
    last_response.body.should == "{\"front\":{\"green\":1,\"orange\":0,\"red\":0},\"left\":{\"green\":1,\"red\":0}}"

    get '/lines'
    last_response.body.should == "{\"front\":{\"green\":1,\"orange\":0,\"red\":0},\"left\":{\"green\":1,\"red\":0}}"
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

  unless ENV.has_key? 'TRAVIS'
    it "should return a custom 404 & 500 error pages" do
      get '/left/red/bad/url'
      last_response.status.should == 404
      last_response.body.should =~ /traffic-lights-lost/

      post '/left/red/4'
      last_response.status.should == 500
      last_response.body.should =~ /traffic-lights-ko/
    end
  end
end
