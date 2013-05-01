#! /usr/bin/env ruby
require 'sinatra'

class TrafficLightPiServer < Sinatra::Base
  configure do
    @@lines = Hash.new(Hash.new(0))
  end

  get '/' do
    "Hello World!"
  end

  # Get current status for one light/color in one line
  get '/:line/:color' do
    line = params[:line]
    color = params[:color]

    @@lines[line][color].to_s
  end

  # Set status of one light/color in one line
  get '/:line/:color/:state' do
    line = params[:line]
    color = params[:color]
    state = params[:state]

    @@lines[line] = Hash.new unless @@lines.has_key? line
    @@lines[line][color] = Hash.new unless @@lines[line].has_key? color

    @@lines[line][color] = state
  end

  run! if app_file == $0
end
