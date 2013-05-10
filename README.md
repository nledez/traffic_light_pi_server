# TrafficLightPiServer

A traffic light serveur for Raspberry π

Current build:
[![Build Status](https://travis-ci.org/nledez/traffic_light_pi_server.png)](https://travis-ci.org/nledez/traffic_light_pi_server)

## Installation

Add this line to your application's Gemfile:

    gem 'traffic_light_pi_server'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install traffic_light_pi_server

Need to install mpg123 before if you want play sound:

OSX:

```brew install mpg123```

Debian like:

```apt-get install mpg123```

## Usage

Launch example in production

If you missing this part server listen only on localhost:4567

Launch as root on π server:

```# RACK_ENV=production ./example_server.rb```

Open a browser:

http://<π address>:4567/

Enjoy.

## Contributing

1. Fork it (https://github.com/nledez/traffic_light_pi_server)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Thanks to msaling for lights:

http://www.vectoropenstock.com/1358-Vector-Traffic-Light-vector

Thanks to Per aspera ad Astra for london traffic lights:

http://commons.wikimedia.org/wiki/File:London_traffic-lights.JPG

Thanks to jenniferboyer for broken traffic lights:

http://www.flickr.com/photos/jenniferboyer/5252129732/
