traffic_light_pi_server
=======================

A traffic light serveur for Raspberry π

Current build:
[![Build Status](https://travis-ci.org/nledez/traffic_light_pi_server.png)](https://travis-ci.org/nledez/traffic_light_pi_server)

Launch example in production
----------------------------

Need to install mpg123 before if you want play sound:

OSX: ```brew install mpg123```

Debian like: ```apt-get install mpg123```

If you missing this part server listen only on localhost:4567

Launch as root on π server:
```# RACK_ENV=production ./example_server.rb```

Open a browser:

http://<π address>:4567/

Enjoy.

Credits
=======

Thanks to msaling for lights:
http://www.vectoropenstock.com/1358-Vector-Traffic-Light-vector

Thanks to Per aspera ad Astra for london traffic lights:
http://commons.wikimedia.org/wiki/File:London_traffic-lights.JPG

Thanks to jenniferboyer for broken traffic lights:
http://www.flickr.com/photos/jenniferboyer/5252129732/
