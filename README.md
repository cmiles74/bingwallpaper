# Bing Wallpaper

This project provides a simple Ruby script that will download the
"Image of the Day" from [Bing][0] and then sets it as your current
wallpaper.

## How It Works

I wrote this script with my own environment in mind, so it's pretty
simple-minded. It fetches the XML describing today's image, then
fetches the  1920x1200 sized version. Lastly, it uses [Feh][1] to set
the wallpaper for your environment. I've tested it in [i3][2] and
nowhere else.

## Using the Script

Easy-peasy, just put the script in your path and mark it
executable. Invoke without arguments...

    bing-wallpaper


***
[0]: https://www/bing.com
[1]: http://feh.finalrewind.org/
[2]: http://i3wm.org/