# catlock

## A cat proof screen lock 

    this is a vala port of my c program (https://github.com/darkoverlordofdata/kitty-cat-lock/)


###  What is cat proof?

Screen lock programs can get pretty complex, as they can allow you to do things such as adjust your volume or disable wifi without unlocking your screen.

But Bal jumps on, lays on, and attacks my keyboard. She has, among other things, filled my hard drive with screen captures in chromeos, frozen mate screenlock, leading to a hard reboot, and even crashed metalock, letting her do further evil things to my computer,

All of this cool functionality has been stripped out of catlock - it does 2 things:

* display the date and time
* accept your password

Bal has 'paw-tested' catlock, and has not been able to do anything evil to my computer for a while.


## Usage
    Usage:
    com.github.darkoverlordofdata.catlock [OPTION?]

    Help Options:
    -h, --help       Show help options

    Application Options:
    --verbosity      verbose level
    --scrot          scrot screen capture
    --calendar       holiday calendar
    --as_user        as user
    --font           font
    --version        version


## install:

```bash
meson build --prefix=/usr
ninja -C build
sudo ninja -C build install
sudo chmod 755 /usr/local/bin/com.github.darkoverlordofdata.catlock
sudo chmod u+s /usr/local/bin/com.github.darkoverlordofdata.catlock

glib-compile-schemas /usr/local/share/glib-2.0/schemas

/usr/local/share/glib-2.0/schemas/com.github.darkoverlordofdata.catlock.gschema.xml

```

Then add to .config/openbox/rc.xml
```
<keybind key="W-l">
    <action name="Execute">
    <command>com.github.darkoverlordofdata.catlock</command>
    </action>
</keybind>
```

### testing: 

    com.github.darkoverlordofdata.catlock -a <user>

#### return key
```bash
[darko@NomadBSD:~/GitHub/catlock] com.github.darkoverlordofdata.catlock
Segmentation fault
```

## todo

display today's holiday along with date. Example usage:

    com.github.darkoverlordofdata.catlock --calendar orage

load fonts from /usr/local/share/fonts using imlib2, removing the dependacy on Xft.

use imlib2 for scaling and image blending so that functionality can be removed from badabing.
this will de-couple the 2 programs allowing catlock to work seamlessly with any background picture source.


![Screenshot](https://github.com/darkoverlordofdata/catlock/raw/master/assets/0.png "Screenshot")

![Screenshot](https://github.com/darkoverlordofdata/catlock/raw/master/assets/1.png "Screenshot")

![Screenshot](https://github.com/darkoverlordofdata/catlock/raw/master/assets/2.png "Screenshot")


