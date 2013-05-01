#! /usr/bin/env ruby
require 'sinatra'

class TrafficLightPiServer < Sinatra::Base
  get '/' do
    "Hello World!"
  end

  get '/0/red' do
    "0"
  end

  run! if app_file == $0
end
