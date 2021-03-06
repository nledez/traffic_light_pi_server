require 'sinatra'
require 'sinatra/json'
require 'haml'
if RUBY_PLATFORM == 'arm-linux-eabihf'
  require "wiringpi"
end

class TrafficLightPiServer < Sinatra::Base
  helpers Sinatra::JSON

  def self.init_lights
    unless defined? @@mp3player
      @@mp3player = "mpg123"
    end

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
          pin = get_pin(line, light)
          @@io.mode(pin, OUTPUT)
          @@lines[line][light] = @@io.read(pin)
        else
          @@lines[line][light] = 0
        end
      end
    end
  end

  # A custom 500
  error do
    haml :'500'
  end

  # A custom 404
  not_found do
    haml :'404'
  end

  # Put a default page
  get '/' do
    @lines = @@lines
    @line_map = @@line_map
    haml :index, :format => :html5
  end

  get '/lines' do
    json @@lines
  end

  get '/play/:sound' do
    sound = params[:sound]
    mp3 = "#{@@sound_dir}/#{sound}.mp3"
    if File.exist? mp3
      pid = fork{ exec @@mp3player, '-q', mp3 }
      "Played with pid: #{pid}"
    else
      status 404
    end
  end

  # Reset all lines
  post '/reset' do
    @@line_map.each do |line, lights|
      reset_line(line)
    end
    json @@lines
  end

  # Reset one line
  post '/:line/reset' do
    line = params[:line].to_sym
    reset_line(line)
    json @@lines[line]
  end

  # Get current status for one light/color in one line
  get '/:line/:light' do
    line = params[:line].to_sym
    light = params[:light].to_sym

    #pin = get_pin(line, light)
    #state = @@lines[line][light.to_sym]
    json @@lines[line][light.to_sym]
  end

  # Set status of one light/light in one line
  post '/:line/:light/:state' do
    line = params[:line].to_sym
    light = params[:light].to_sym
    state = params[:state].to_i

    if state != 0 && state != 1
      raise "Bad state value (must be 0 or 1)"
    end

    write_light(line, light, state).to_s
  end

  def get_pin(line, light)
    @@line_map[line][light]
  end

  def write_light(line, light, state)
    pin = get_pin(line, light)
    if @@pi_enabled
      @@io.write(pin, state)
      @@lines[line][light] = @@io.read(pin)
    else
      @@lines[line][light] = state
    end
  end

  def reset_line(line)
    @@line_map[line].each do |light, pin|
      write_light(line, light, 0)
    end
    write_light(line, :green, 1)
  end
end
