* 0.1

    * stabilized initial design
    * make more palatable to linux
    * change licenseing to GPL

* 0.2 - 9/28/2019 - bug fixes

    * honor dark ui preference
    * don't fail if notification service is not available
    * use pcmanfm when session is LXDE-pi

* 0.3 - 11/27/2020 - bug fixes

    * update password input when backspace is pressed
    * fedora 33 mate - issues with libxcrypt. Use param --secret when crypt is not working

* 0.4 - 12/12/2020

    * prefer PIN rather than password
    * store preferences in dconf
    * re-write key input loop
    * re-write imlib2.vapi to remove oop style bindings
    * fix time to GLib.Time.local(time_t())

* 0.5 - 12/24/2020

    * add descriptive text

* 0.6 - 1/11/2021

    * collapse ~/.local/catlock/themes