#! /usr/bin/env ruby
require 'sinatra'

class TrafficLightPiServer < Sinatra::Base
  def initialize(line_mapping)
    @@line_map = line_mapping
    @@lines = Hash.new(Hash.new(0))
    super
  end

  # Put a default page
  get '/' do
    "Hello World!"
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

    @@lines[line] = Hash.new unless @@lines.has_key? line
    @@lines[line][color] = Hash.new unless @@lines[line].has_key? color

    @@lines[line][color] = state
    pin = @@line_map[line][color.to_sym]
    "#{pin}:#{state}"
  end
end
