
[![Gem Version](https://badge.fury.io/rb/bingwallpaper.svg)](http://badge.fury.io/rb/bingwallpaper)

# Bing Wallpaper

This project provides a simple Ruby script that will download the "Image of the
Day" from [Bing][0] and then sets it as your current wallpaper. There are
several tools out there that do this, this particular tool works under Linux.

If you find this code useful in any way, please feel free to...

<a href="https://www.buymeacoffee.com/cmiles74" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>


## How It Works

I wrote this script with my own environment in mind, so it's pretty
simple-minded. It fetches the XML describing today's image, then fetches the
1920x1200 sized version if it's available, the lower resolution version if not.
Lastly, it uses [Feh][1], [swaymsg][3] or Gnome to set the wallpaper for your
environment. I've tested it in [i3][2], [Sway][4] and Gnome 3.14.2 and nowhere
else.

## Using the Script

Just install the gem...

    gem install bingwallpaper

And then invoke the script like so to set your wallpaper and lock screen to the
Bing Picture of the Day in Gnome.

    bingwallpaper -g -l

Here's the usage information...

```
Usage: bingwallpaper [options]
    -g, --gnome                      Set Gnome background
    -l, --lock                       Set Gnome lock screen background
    -f, --feg                        Use feh to set the  background (the default)
    -s, --sway                       Use swaymsg to set the background, overwrite \
                                       ~/.config/sway/config.d/wallpaper
    -h, --help                       Prints this help
```

----
[0]: https://www.bing.com
[1]: http://feh.finalrewind.org/
[2]: http://i3wm.org/
[3]: https://github.com/swaywm/sway/blob/master/swaymsg/swaymsg.1.scd
[4]: https://swaywm.org/
