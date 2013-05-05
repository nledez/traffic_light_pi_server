#! /usr/bin/env ruby
require 'sinatra'
require 'haml'
if RUBY_PLATFORM == 'arm-linux-eabihf'
  require "wiringpi"
end

class TrafficLightPiServer < Sinatra::Base
  def self.init_lights
    unless defined? @@sound_dir
      @@sound_dir = "#{File.dirname(__FILE__)}/sounds"
    end

    @@pi_enabled = nil
    if RUBY_PLATFORM == 'arm-linux-eabihf'
      @@io = WiringPi::GPIO.new
      @@pi_enabled = true
    end

    @@lines = Hash.new
    @@line_map.each_key do |line|
      @@lines[line] = Hash.new
      @@line_map[line].each_key do |light|
        if @@pi_enabled
          pin = @@line_map[line][light]
          @@io.mode(pin, OUTPUT)
          @@lines[line][light] = @@io.read(pin)
        else
          @@lines[line][light] = 0
        end
      end
    end
  end

  # Put a default page
  get '/' do
    @lines = @@lines
    @line_map = @@line_map
    haml :index, :format => :html5
  end

  get '/play/:sound' do
    sound = params[:sound]
    mp3 = "#{@@sound_dir}/#{sound}.mp3"
    if File.exist? mp3
      pid = fork{ exec 'mpg123','-q', mp3 }
      "Played with pid: #{pid}"
    else
      status 404
    end
  end

  # Get current status for one light/color in one line
  get '/:line/:light' do
    line = params[:line].to_sym
    light = params[:light].to_sym

    pin = @@line_map[line][light]
    state = @@lines[line][light.to_sym]
    "#{pin}:#{state}"
  end

  # Set status of one light/light in one line
  get '/:line/:light/:state' do
    line = params[:line].to_sym
    light = params[:light].to_sym
    state = params[:state].to_i

    pin = @@line_map[line][light.to_sym].to_i
    if @@pi_enabled
      @@io.write(pin, state)
      state = @@lines[line][light] = @@io.read(pin)
    else
      @@lines[line][light] = state
    end
    "#{pin}:#{state}"
  end
end
