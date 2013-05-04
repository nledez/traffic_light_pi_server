#! /usr/bin/env ruby
require 'sinatra'
require 'haml'

class TrafficLightPiServer < Sinatra::Base
  def self.init_lights
    @@lines = Hash.new
    @@line_map.each_key do |line|
      @@lines[line] = Hash.new
      @@line_map[line].each_key do |light|
        @@lines[line][light] = 0
      end
    end
  end

  # Put a default page
  get '/' do
    @lines = @@lines
    @line_map = @@line_map
    haml :index, :format => :html5
  end

  # Get current status for one light/color in one line
  get '/:line/:color' do
    line = params[:line].to_i
    color = params[:color].to_sym

    pin = @@line_map[line][color]
    state = @@lines[line][color.to_sym]
    "#{pin}:#{state}"
  end

  # Set status of one light/color in one line
  get '/:line/:color/:state' do
    line = params[:line].to_i
    color = params[:color].to_sym
    state = params[:state]

    @@lines[line][color] = state
    pin = @@line_map[line][color.to_sym]
    "#{pin}:#{state}"
  end
end
