#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'lib', 'traffic_light_pi_server.rb')

class TrafficLightPiServer < Sinatra::Base
  configure do
    @@line_map = {
      0 => {
        :red => 4,
        :green => 5,
      },
      1 => {
        :red => 12,
        :orange => 13,
        :green => 14,
      },
    }
    init_lights
  end
end

TrafficLightPiServer.run!
