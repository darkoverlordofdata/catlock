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

sudo apt install libxpm-dev
sudo apt install libimlib2-dev

```bash
(meson build --prefix=/usr/local)
ninja -C build
sudo ninja -C build install

sudo glib-compile-schemas /usr/local/share/glib-2.0/schemas

```

## Enable

### openbox
Add to .config/openbox/rc.xml
```
<keybind key="W-l">
    <action name="Execute">
    <command>com.github.darkoverlordofdata.catlock</command>
    </action>
</keybind>
```

### mate
in dconf editor, org.mate.marco.keybinding-commands
command-1 mate-screensaver-command --lock
dm-tool lock

com.github.darkoverlordofdata.catlock


![Screenshot](https://github.com/darkoverlordofdata/catlock/raw/master/assets/0.png "Screenshot")

![Screenshot](https://github.com/darkoverlordofdata/catlock/raw/master/assets/1.png "Screenshot")

![Screenshot](https://github.com/darkoverlordofdata/catlock/raw/master/assets/2.png "Screenshot")

sudo cp ./data/com.github.darkoverlordofdata.catlock.gschema.xml /usr/local/share/glib-2.0/schemas
sudo glib-compile-schemas /usr/local/share/glib-2.0/schemas

### PIN or Password?

Catlock now prefers to use PIN for unlocking the screen. The default, 999999 can be reset in dconf at com/github/darkoverlordofdata/catlock/pin

If you want to use password instead, you need to suid the executable:
```
sudo chmod 755 /usr/local/bin/com.github.darkoverlordofdata.catlock
sudo chmod u+s /usr/local/bin/com.github.darkoverlordofdata.catlock
```



### bsd errata

dependency('X11') s.b. dependency('x11'),


