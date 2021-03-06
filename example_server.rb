#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'lib', 'traffic_light_pi_server.rb')

class TrafficLightPiServer < Sinatra::Base
  configure do
    @@line_map = {
      :devant => {
        :red => 12,
        :orange => 13,
        :green => 14,
      },
      :gauche => {
        :red => 4,
        :green => 5,
      },
      :fond => {
        :red => 6,
        :orange => 10,
        :green => 11,
      },
      :droite => {
        :red => 0,
        :green => 3,
      },
    }
    init_lights
  end
end

TrafficLightPiServer.run!
