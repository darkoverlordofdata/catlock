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
    X.Colormap cm;
    X.Cursor invisible;
    X.Visual visual;
    X.Event ev;             // input events
    X.FtDraw drawable;      // freetype drawable
    X.FtColor color;        // freetype color to draw
    X.FtColor bgcolor;      // freetype color tp draw
    X.FtFont *font_small;   // small font
    X.FtFont *font_name;    // font for name
    X.FtFont *font_pwd;     // font for password
    X.FtFont *font_time;    // font for time
    X.FtFont *font_date;    // font for date
    int screen;             // screen of display
    int width;              // width of screen
    int height;             // height of screen

    /* Application values */
    //  char* calendar;
    //  Holidays* holidays;
    Parameters parms;
    User.Passwd pw;
    ApplicationState state;
    string user_name = "";
    string full_name = "";
    string salt = "";
    string passwd = "";
    string uline = "";
    string pline = "";
    string tline = "";
    string dline = "";
    string imgfn = "";
    string boximgfn = "";
    string fontname_small = "";
    string fontname_name = "";
    string fontname_pwd = "";
    string fontname_time = "";
    string fontname_date = "";
    uint len;
    char buf[256];
    ulong ksym;
    bool running;
    bool first = true;
    int count = 0;
    int ticks = 0;
    int inactive = 0;
    const int timeout = 1000;
    const int pass_num_show = 32;

    /**
     * Run:
     * 
     * com.github.darkoverlordofdata.binglock
     */
    public MainWindow(Parameters parms) 
    {
        this.parms = parms;

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
        if (parms.verbosity > 1) { 
            print(@"user_name       = $user_name\n");
            print(@"full_name       = $full_name\n");
        }

        display = new Display();
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

        Imlib2.context_set_dither(1);
        Imlib2.context_set_display(display);
        Imlib2.context_set_visual(visual);

        /* Load the window level background image */
        generateImageFilename();
        /* Load the top level background image */
        var image = Imlib2.Image.create_from_file(imgfn);
        image.set_context();
        int width = Imlib2.image_get_width();
        int height = Imlib2.image_get_height();

        /* Set the top level background image */
        var pixm = X.create_pixmap(display, window, width, height, depth);
        Imlib2.context_set_drawable(pixm);
        Imlib2.render_image_on_drawable(0, 0);
        X.set_window_background_pixmap(display, window, pixm);
        X.free_pixmap(display, pixm);

        /* Load the panel background image */
        var box_image = Imlib2.Image.create_from_file(boximgfn);
        box_image.set_context();
        int panel_width = Imlib2.image_get_width();
        int panel_height = Imlib2.image_get_height();

        active = panel = X.create_simple_window(display, window, 0, 0, panel_width, panel_height,
                              0, fg.pixel, bg.pixel);

        var pix = X.create_pixmap(display, panel, panel_width, panel_height, depth);
        Imlib2.context_set_drawable(pix);
        Imlib2.render_image_on_drawable(0, 0);
        X.set_window_background_pixmap(display, panel, pix);
        X.free_pixmap(display, pix);

        // set foreground and backgound default colors
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
        generateFontNames(parms.font);
        font_name = display.font_open_name(screen, fontname_name);

        if (font_name == null) {
            print(@"font \"$(parms.font)\" does not exist - using fallback.\n");
            generateFontNames("6x10");
            font_name = display.font_open_name(screen, fontname_name);
        }
        font_small = display.font_open_name(screen, fontname_small);
        font_pwd = display.font_open_name(screen, fontname_pwd);
        font_time = display.font_open_name(screen, fontname_time);
        font_date = display.font_open_name(screen, fontname_date);

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
            buf[0] = 0;
            num = X.lookup_string(&ev.xkey, buf, 256, &ksym, null);
            buf[num] = 0;

            switch(ksym) {
                case X.K_Return:
                    if (parms.verbosity > 1) { 
                        print("[return]\n"); 
                    }

                    if (salt == "") salt = get_password();
                    if (salt == User.crypt(passwd, salt)) running = false;

                    if (running) {
                        display.bell(100);
                        print("Password failed!! Try again!\n");
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

                    running = false;
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
                    }

                    break;

                default: 
                    if (parms.verbosity > 1) { 
                        print(@"[other: $((string)buf)]\n"); 
                    }

                    if (num != 0 && !buf[0].iscntrl() && (len + num < 256)) {
                        passwd = passwd + (string)buf;
                        len += num;
                        if (pline.length < pass_num_show) { 
                            pline = pline + "*"; 
                        }
                        draw();
                        //  print(@"new_pline_len = $new_pline_len");
                        //  if ((parms.verbosity > 1) && (pline.length < pass_num_show)) { 
                            //  print("*"); 
                        //  }
                    }
                    else if (len + num >= 256) {
                        passwd = "";
                        display.bell(100);
                        if (parms.verbosity > 1) { print("(terminated at 255 chars)"); }
                        print("Specified password is *unreasonably* long!! Try again!\n");
                        len = 0;
                        pline = "";
                        draw();
                    }
                    //  print(@"passwd = $passwd\n");

                    break;
            }
            draw();
        }
        else if (ev.type == EventType.MotionNotify || ev.type == EventType.ButtonPress)
            draw();

        ev.type = -1;
        /* check for keyboard input events */
        while(display.pending() > 0) {
            display.next_event(ref ev);
        }
        /* sleep until next frame */
        Thread.usleep(10000);
        if (count++ > 20000) running = false;


    }

    /**
     * Clean up
     */
     public override void dispose() {
        //  destroy_window(display, window);
        display.ungrab_pointer((int)CURRENT_TIME);
        display.color_free(visual, cm, &color);
        //  draw_destroy(drawable); 
        X.destroy_window(display, window);
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
     public void generateFontNames(string name) {
        parms.font = name;
        string fontsize_small   = "-8";
        string fontsize_name    = "-24";
        string fontsize_pwd     = "-24";
        string fontsize_date    = "-32";
        string fontsize_time    = "-64";

        fontname_small = parms.font + fontsize_small;
        fontname_name = parms.font + fontsize_name;
        fontname_pwd = parms.font + fontsize_pwd;
        fontname_date = parms.font + fontsize_date;
        fontname_time = parms.font + fontsize_time;
    }

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
        var now = new DateTime.now_local ();        
        string instruc = "Enter password";

        tline = now.format("%l:%M");
        dline = now.format("%A, %B %d");
    
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
            drawable.draw_string(&color, font_time, 40, 600, (char *)tline, tline.length);
            drawable.draw_string(&color, font_date, 40, 670, (char *)dline, dline.length);
            break;
    
        case ApplicationPassword:
            drawable.draw_string(&color, font_name, c,  480, (char *)uline, uline.length);
            drawable.draw_rect(&color, c1-1, 529, 302, 32);
            drawable.draw_rect(&bgcolor, c1, 530, 300, 30);
            drawable.draw_string(&color, font_pwd,  c1, 560, (char *)pline, pline.length);
            drawable.draw_string(&color, font_small,  c2, 660, (char *)instruc, instruc.length);
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
