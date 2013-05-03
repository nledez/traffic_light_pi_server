#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'lib', 'traffic_light_pi_server.rb')

class TrafficLightPiServer < Sinatra::Base
  configure do
    @@line_map = {
      0 => {
        :green => 22,
        :orange => 23,
        :red => 24
      },
      1 => {
        :green => 4,
        :red => 5
      }
    }
    init_lights
  end
end

TrafficLightPiServer.run!
