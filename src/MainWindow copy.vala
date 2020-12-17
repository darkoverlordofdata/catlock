/* ******************************************************************************
 * Copyright 2020 bruce davidson <darkoverlordofdata@gmail.com>.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the <organization> nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ******************************************************************************/
using X;
using Imlib2;
using User;
using Config;

/**
 * Wallpaper Application
 */
public class CatLock.MainWindow : GLib.Object 
{
    /* X11 values */
    X.Display display;      // application display
    X.Window root;          // rot window
    X.Window active;        // the active window
    X.Window window;        // top level window
    X.Window panel;         // drawing panel
    X.Event ev;             // input events
    X.Colormap cm;          // overhead
    X.Cursor invisible;     // overhead
    X.Visual visual;        // overhead

    X.FtDraw drawable;      // freetype drawable
    X.FtColor color;        // freetype foreground color to draw
    X.FtColor bgcolor;      // freetype background color to draw
    X.FtFont * font_08;     // freetype small font
    X.FtFont * font_16;     // freetype medium font
    X.FtFont * font_24;     // freetype font for password
    X.FtFont * font_64;     // freetype font for time
    X.FtFont * font_32;     // freetype font for date

    string fontname_08 = "";
    string fontname_16 = "";
    string fontname_24 = "";
    string fontname_64 = "";
    string fontname_32 = "";
    int screen;             // screen of display
    int width;              // width of screen
    int height;             // height of screen
    int offset;

    /* Application values */
    Parameters parms;
    User.Passwd pw;
    ApplicationState state;
    Holidays? holidays;
    string user_name = "";
    string full_name = "";
    string salt = "";
    string passwd = "";
    string instruc = "Enter PIN";
    string uline = "";
    string pline = "";
    string imgfn = "";
    string boximgfn = "";
    char tline[BUFLEN];
    char dline[BUFLEN];
    char buf[BUFLEN];
    string[] today_is;
    string[] tomorrow_is;
    int today = 0;
    int count = 0;
    int ticks = 0;
    int inactive = 0;
    const int timeout = 1000;
    const int pass_num_show = 32;
    uint len;
    ulong ksym;
    bool running = false;
    bool first = true;
    bool rollover = false;

    int get_today() {
        var now = time_t();
		var t = GLib.Time.local(now);
		
		return (1900+t.year)*10000 + (t.month+1)*100 + t.day;

    }
    /**
     * Run:
     * 
     * com.github.darkoverlordofdata.catlock
     */
    public MainWindow(Parameters parms) 
    {

        this.parms = parms;
        var now = time_t();
		var t = GLib.Time.local(now);
		
        today = get_today();
        
        if (parms.calendar) {

            var config = new Settings(APPLICATION_ID);
            var ics = config.get_string("calendar-path");
            var path = @"$(Environment.get_home_dir())/$ics";

            if (FileUtils.test(path, FileTest.EXISTS)) {
                holidays = new Holidays.from_path(path);

                //  holidays.list.foreach((entry) => {
                //      print(@"$(entry.date) $(entry.description)\n");
                //  });
    
                holidays.today = 20200310;
                holidays.tomorrow = 20200311;
        
                today_is = holidays.today_is();
                tomorrow_is = holidays.tomorrow_is();

                //  print("Today:\n");
                //  foreach (var s in today_is) {
                //      print(@"$s\n");
                //  }
        
                //  print("Tomorrow:\n");
                //  foreach (var s in tomorrow_is) {
                //      print(@"$s\n");
                //  }
            }

    
        }

        initialize();
        processEvent(ApplicationInit);        
        run();
        dispose();
    }


    /**
     * Initialization
     */
    public void initialize() {

        pw = User.Passwd.from_uid(User.getuid());
        user_name = pw.name;
        full_name = pw.gecos;
        int pos;
        while ((pos = full_name.last_index_of(",")) != -1 ) {
            full_name = full_name.substring(0, pos);
        }
        if (parms.verbosity > 1) { 
            print(@"user_name       = $user_name\n");
            print(@"full_name       = $full_name\n");
        }

        display = new X.Display();
        if (display == null) {
            die("Cannot open display\n");
        }
        screen = display.default_screen();
        int depth = display.default_depth(screen);
        root = display.root_window(screen);
        width = display.width(screen);
        height = display.height(screen);
        cm = display.default_color_map(screen);


        X.Color bg = { 0, 0, 0, 0 };              // black
        X.Color fg = { 0, 65535, 65535, 65535 };  // white
        display.alloc_color(cm, &bg);
        display.alloc_color(cm, &fg);

        var wa = X.SetWindowAttributes(){ override_redirect = true, background_pixel = bg.pixel };
        visual = display.default_visual(screen);
        
        window = create_window(display, root, 0, 0, width, height, 
        //  window = create_window(display, root, 100, 30, width/4, height/4, 
            0, depth, (uint)X.COPY_FROM_PARENT, 
            visual, X.CW.OverrideRedirect | X.CW.BackPixel, ref wa);

        imlib_context_set_dither(1);
        imlib_context_set_display(display);
        imlib_context_set_visual(visual);

        generateImageFilename();
        ////////////////////////////////////////////
        /* Load the window level background image */
        ////////////////////////////////////////////
        /* Load the top level background image */
        var image = imlib_load_image(imgfn);
        imlib_context_set_image(image);
        int width = imlib_image_get_width();
        int height = imlib_image_get_height();

        /* Set the top level background image */
        var pixm = X.create_pixmap(display, window, width, height, depth);
        imlib_context_set_drawable(pixm);
        imlib_render_image_on_drawable(0, 0);

        X.set_window_background_pixmap(display, window, pixm);
        X.free_pixmap(display, pixm);
        ////////////////////////////////////////////

        /////////////////////////////////////
        /* Load the panel background image */
        /////////////////////////////////////
        //  var box_image = imlib_Image.create_from_file(boximgfn);
        var box_image = imlib_load_image(boximgfn);
        //  box_image.set_context();
        imlib_context_set_image(box_image);
        int panel_width = imlib_image_get_width();
        int panel_height = imlib_image_get_height();

        active = panel = X.create_simple_window(display, window, 0, 0, panel_width, panel_height,
                              0, fg.pixel, bg.pixel);

        var pix = X.create_pixmap(display, panel, panel_width, panel_height, depth);
        imlib_context_set_drawable(pix);
        imlib_render_image_on_drawable(0, 0);

        X.set_window_background_pixmap(display, panel, pix);
        X.free_pixmap(display, pix);
        /////////////////////////////////////

        //////////////////////////////////////////////
        // set foreground and backgound default colors
        //////////////////////////////////////////////
        X.Color black, dummy;
        var xrb = X.RenderColor() { red = bg.red, green = bg.green, blue = bg.blue, alpha = 0xffff };
        var xrc = X.RenderColor() { red = fg.red, green = fg.green, blue = fg.blue, alpha = 0xffff };
        display.alloc_color_value(visual, cm, &xrb, &bgcolor);
        display.alloc_color_value(visual, cm, &xrc, &color);
        display.alloc_named_color(cm, "black", &black, &dummy);

        char curs[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
        var pmap = display.create_bitmap_from_data(window, curs, 8, 8);
        invisible = display.create_pixmap_cursor(pmap, pmap, &black, &black, 0, 0);

        // load fonts
        set_font_name(parms.font);
        font_08 = display.font_open_name(screen, fontname_08);
        font_16 = display.font_open_name(screen, fontname_16);
        font_24 = display.font_open_name(screen, fontname_24);
        font_32 = display.font_open_name(screen, fontname_32);
        font_64 = display.font_open_name(screen, fontname_64);

        if (!grabPointer())
            die("Unable to grab mouse pointer");

        if (!grabKeyboard())
            die("Unable to grab keyboard");

        display.sync(false);
        display.map_window(window);
    }


    /**
     * Run
     */
     public void run() {
        uline = full_name;
        pline = "";
        passwd = "";
        salt = "";
        ev = {};
        running = true;
        count = 0;
        ticks = 0;
        inactive = timeout;
    
        draw();
        while (running) {
            /**
                this 'works' but is insecure. It should just reload and redisplay the image.
                
                Would this would be better done as a dbus message from badabing? 


             */
            //  if (rollover) {
            //      var dt = new DateTime.now_local();
            //      if (dt.get_hour() == 0 && dt.get_minute() > 2) {
            //          /*
            //           * if running after 12:02 am and started on the previous day then restart
            //           */
            //          Process.spawn_command_line_async("com.github.darkoverlordofdata.catlock --calendar");
            //          Process.exit(0);
            //      }
            //  }
            run_loop();
        }
    }

    /**
     * Run Loop
     */
    public void run_loop() {

        int num;

        if (ev.type == X.EventType.KeyRelease) {
            buf[0] = 0;
        }
        else if (ev.type == X.EventType.KeyPress) {
            processEvent(ApplicationKeyPress);
            inactive = timeout;
            if (parms.scrot) {
                parms.scrot = false;
                try {
                    Process.spawn_command_line_async("/usr/local/bin/scrot -d 1");
                }
                catch (GLib.SpawnError ex) { }
            }
            //  buf[0] = 0;
            //  num = X.lookup_string(&ev.xkey, buf, BUFLEN, &ksym, null);
            //  buf[num] = 0;

            ksym = display.keycode_to_keysym((uchar)ev.xkey.keycode, 0);
            num = 1;
            buf[0] = (char)ksym;
            buf[num] = 0;

            //  print("ksym) %lx - %lx\n", ksym, k1);


            switch(ksym) {
                case X.K_Return:
                    if (parms.verbosity > 1) { 
                        print("[return]\n"); 
                    }

                    if (parms.pin == null) {
                        if (salt == "") salt = get_password();
                        if (salt == (string)User.crypt(passwd, salt)) running = false;
                    }
                    else 
                    {
                        print("pin = %s\n", parms.pin);
                        if (passwd == parms.pin) running = false;
                    }

                    if (running) {
                        display.bell(100);
                        print("PIN failed - [%s] - try again!\n", passwd);
                        passwd = "";
                        pline = "";
                        draw();
                    }
                    len = 0;

                    if (!running) { 
                        print("Unlocking Screen..."); 
                    }

                    break;

                case X.K_Escape:
                    if (parms.verbosity > 1) { 
                        print("[escape]\n"); 
                    }

                    //  running = false;
                    if (state == ApplicationDate) break;

                    if (first) {
                        first = false;
                        break;
                    }
                    len = 0;
                    pline = "";
                    processEvent(ApplicationEscape);

                    break;

                case X.K_BackSpace:
                    if (parms.verbosity > 1) { 
                        print("[backspace]\n"); 
                    }

                    if (len>0) {
                        --len;
                        pline = pline.substring(0, pline.length-1);
                        draw();
                        passwd = passwd.substring(0, passwd.length-1);
                    }

                    break;

                default: 
                    if (parms.verbosity > 1) { 
                        print(@"[other: $((string)buf)]\n"); 
                    }

                    if (num != 0 && !buf[0].iscntrl() && (len + num < BUFLEN)) {
                        passwd = passwd + (string)buf;
                        len += num;
                        if (pline.length < pass_num_show) { 
                            pline = pline + "*"; 
                        }
                        draw();
                        if (parms.pin != null) {
                            if (passwd == parms.pin) running = false;
                        } 
                        else {
                            print("failed : %s\n", passwd);
                        }
    
    
                    }
                    else if (len + num >= BUFLEN) {
                        passwd = "";
                        display.bell(100);
                        if (parms.verbosity > 1) { print("(terminated at 255 chars)"); }
                        print("Specified password is *unreasonably* long!! Try again!\n");
                        len = 0;
                        pline = "";
                        draw();
                    }

                    break;
            }
            draw();
        }
        else if (ev.type == EventType.MotionNotify || ev.type == EventType.ButtonPress)
            draw();

        ev.type = -1;
        if (inactive > 0) {
            inactive--;
            if (inactive <= 0) {
                len = 0;
                pline = "";
                processEvent(ApplicationTimeout);
            }
        }


        /* check for keyboard input events */
        while(display.pending() > 0) {
            display.next_event(ref ev);
        }

        /* 
         * sleep for .01 second to allow 
         * capture of the x11 keyboard events 
         */
        Thread.usleep(10000);
        if (ticks++ >= 100) {
            // 1.0 fps
            ticks = 0;
            draw();
            if (get_today() > today) rollover = true;
        }
    }

    /**
     * Clean up
     */
     public override void dispose() {
         if (display != null) {
            display.ungrab_pointer((int)CURRENT_TIME);
            display.color_free(visual, cm, &color);
         }
    }

    /**
     * Grab control of the mouse pointer
     */
     public bool grabPointer() {
        var result = display.grab_pointer(root, false, 
            EventMask.ButtonPressMask | EventMask.ButtonReleaseMask | EventMask.PointerMotionMask,
            GrabMode.Async, GrabMode.Async, None, invisible, (int)CURRENT_TIME);

        return (result == GRAB_SUCCESS);
    }
    
    /**
     * Grab control of the keyboard
     */
     public bool grabKeyboard() {
        var result = display.grab_keyboard(root, false,
            GrabMode.Async, GrabMode.Async, (int)CURRENT_TIME);

        return (result == GRAB_SUCCESS);
    }

    /**
     * Generate the required font names
     */
     public void set_font_name(string name) {

        parms.font = name;
        switch (width*10000+height)
        {
            case 13660768:
                offset = 0;
                fontname_08 = parms.font + "-8";
                fontname_16 = parms.font + "-16";
                fontname_24 = parms.font + "-24";
                fontname_32 = parms.font + "-32";
                fontname_64 = parms.font + "-64";
                break;

            case 19201080:
                offset = 12;
                fontname_08 = parms.font + "-12";
                fontname_16 = parms.font + "-24";
                fontname_24 = parms.font + "-36";
                fontname_32 = parms.font + "-48";
                fontname_64 = parms.font + "-96";
                break;

            default:
                offset = 0;
                fontname_08 = parms.font + "-8";
                fontname_16 = parms.font + "-16";
                fontname_24 = parms.font + "-24";
                fontname_32 = parms.font + "-32";
                fontname_64 = parms.font + "-64";
                break;

        }
    }
    //1366x768
    // 1920X1080

    //
    /**
     * Get images to load
     */
     public void generateImageFilename()  {
        
        string types[] = { "png", "jpg", "jpeg", "xpm", "xpm.gz" };

        foreach (var type in types) {
            imgfn = image_filename(user_name, parms.theme, "bg", type);
            if (FileUtils.test(imgfn, FileTest.EXISTS)) break;
        }

        if (parms.verbosity > 1)
            print("background image filename: %s\n", imgfn);

        foreach (var type in types) {
            boximgfn = image_filename(user_name, parms.theme, "box", type);
            if (FileUtils.test(boximgfn, FileTest.EXISTS)) break;
        }
    
       if (parms.verbosity > 1)
            print("box image filename: %s\n", boximgfn);

        if (!FileUtils.test(imgfn, FileTest.EXISTS) || !FileUtils.test(boximgfn, FileTest.EXISTS)) {
            die(@"image $imgfn does not exist\n");
        }
    }

    /**
     * build the image filename
     */
     public string image_filename(string user, string theme, string name, string type) {
        return @"/home/$user/.local/share/catlock/themes/$theme/$name.$type";
    }

    /**
     * draw the text on the screen
     */
     public void draw() {
         
        var now = time_t();
        var local = GLib.Time.local(now);
        var tlen = (int)local.strftime(tline, "%l:%M");
        var dlen = (int)local.strftime(dline, "%A, %B %-d");
    
        X.clear_window(display, active);
    
        /**
         * rough stab at font metrics...
         * 300 pixels wide fits about 17-18 chars at 24 pt. 
         */
        const float fac24 = 300.0f/17.0f;
        /** 
         * and 8pt is 1/3 of 24 pt... 
         */
        const float fac08 = (300.0f/17.0f)/3.0f;

        int c = (width-(int)(uline.length * fac24))/2;
        int c1 = ((width-300)/2);
        int c2 = (width- (int)(instruc.length * fac08))/2;
    
        switch (state) {
    
        case ApplicationDate:
            int row_size = 22;
            int row = 600 - (today_is.length*row_size + tomorrow_is.length*row_size);
            row =(int) ((float)row * ((float)width/1366.0f));
            if (row < 0) row = 0;

            drawable.draw_string(&color, font_64, 40, row, tline, tlen);
            drawable.draw_string(&color, font_32, 40, row+70, dline, dlen);

            var hcount = 0;

            foreach (var s in today_is) {
                hcount += 1;
                drawable.draw_string(&color, font_16, 60, row + 90+(hcount*row_size), s, s.length);
            }

            if (tomorrow_is.length > 0) {
                hcount += 1;
                drawable.draw_string(&color, font_16, 60, row + 90+(hcount*row_size), "[Tomorrow]", 10);
            }
    
            foreach (var s in tomorrow_is) {
                hcount += 1;
                drawable.draw_string(&color, font_16, 60, row + 90+(hcount*row_size), s, s.length);
            }
            
            break;
    
        case ApplicationPassword:
            drawable.draw_string(&color, font_24, c,  480, (char *)uline, uline.length);
            drawable.draw_rect(&color, c1-1, 529, 302, 32);
            drawable.draw_rect(&bgcolor, c1, 530, 300, 30);
            drawable.draw_string(&color, font_24,  c1+offset, 560+offset, (char *)pline, pline.length);
            drawable.draw_string(&color, font_08,  c2, 660, (char *)instruc, instruc.length);
            break;
    
        default: 
            Process.exit(1);
    
        }
    
    }

    /**
     * process state
     */
     public void processEvent(ApplicationEvent evt) {
        switch (evt) {
            case ApplicationInit:
                state = ApplicationDate;
                active = window;
                break;
        
            case ApplicationKeyPress:
                state = ApplicationPassword;
                active = panel;
                break;
        
            case ApplicationTimeout:
                state = ApplicationDate;
                active = window;
                display.unmap_window(panel);
                break;
        
            case ApplicationEscape:
                if (state == ApplicationDate) break;
                state = ApplicationDate;
                active = window;
                display.unmap_window(panel);
                break;
        
        }
        display.define_cursor(active, invisible);
        display.map_raised(active);
        // if the font does not exist, then fallback to fixed and give warning 
        drawable = display.draw_create(active, visual, cm);
        // Display the pixmaps, if applicable 
        clear_window(display, active);
        draw();
        //  application_draw(this);
    
    }

    /**
    * get the use account info
    *
    * only run as root
    */
    string get_password() {
        string rval;
        Passwd pw;

        if (User.geteuid() != 0) {
            die("cannot retrieve password entry (make sure to suid catlock)\n");
        }
        pw = Passwd.from_uid(User.getuid());
        User.endpwent();
        rval =  pw.passwd;

        /* drop privileges */
        if(User.setgid(pw.gid) < 0 || User.setuid(pw.uid) < 0)
            die("cannot drop privileges\n");
        return rval;
    }
}
