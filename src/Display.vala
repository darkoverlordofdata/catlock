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
using Config;

/**
* XDisplay wrapper
*/
public class CatLock.Display : GLib.Object 
{
	/* X11 values */
	public X.Display display;      // application display
	public X.Window root;          // rot window
	public X.Window window;        // top level window
	public X.Event ev;             // input events
	public X.Colormap cm;          // overhead
	public X.Cursor invisible;     // overhead
	public X.Visual visual;        // overhead
	public X.Color bg;
	public X.Color fg;

    public X.FtColor color;        // freetype foreground color to draw
    public X.FtColor bgcolor;      // freetype background color to draw

	public GenericArray<Panel> panels = new GenericArray<Panel>();
	public int screen;             // screen of display
	public int width;              // width of screen
	public int height;             // height of screenlic
	public int depth;
	public string imgfn = "";

	/* Application values */
	/**
	* Run:
	* 
	* com.github.darkoverlordofdata.catlock
	*/
	public Display() 
	{
		display = new X.Display();
		if (display == null) {
			die("Cannot open display\n");
		}
		screen = display.default_screen();
		depth = display.default_depth(screen);
		root = display.root_window(screen);
		width = display.width(screen);
		height = display.height(screen);
		cm = display.default_color_map(screen);

		display.alloc_color(cm, &bg);
		display.alloc_color(cm, &fg);

		var wa = X.SetWindowAttributes(){ override_redirect = true, background_pixel = bg.pixel };
		visual = display.default_visual(screen);
		
		window = create_window(display, root, 0, 0, width, height, 
			0, depth, (uint)X.COPY_FROM_PARENT, 
			visual, X.CW.OverrideRedirect | X.CW.BackPixel, ref wa);

		Imlib2.context_set_dither(1);
		Imlib2.context_set_display(display);
		Imlib2.context_set_visual(visual);

		panels.insert(panels.length, new Panel(this, ""));

		bg = { 0, 0, 0, 0 };              // black
		fg = { 0, 65535, 65535, 65535 };  // white
	
		X.Color black, dummy;
		var xrb = X.RenderColor() { red = bg.red, green = bg.green, blue = bg.blue, alpha = 0xffff };
		var xrc = X.RenderColor() { red = fg.red, green = fg.green, blue = fg.blue, alpha = 0xffff };
		display.alloc_color_value(visual, cm, &xrb, &bgcolor);
		display.alloc_color_value(visual, cm, &xrc, &color);
		display.alloc_named_color(cm, "black", &black, &dummy);

		char curs[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
		var pmap = display.create_bitmap_from_data(window, curs, 8, 8);
		invisible = display.create_pixmap_cursor(pmap, pmap, &black, &black, 0, 0);

		if (!grabPointer())
			die("Unable to grab mouse pointer");

		if (!grabKeyboard())
			die("Unable to grab keyboard");

		display.sync(false);
		display.map_window(window);
	}

	public X.FtFont * font_open_name(string name) {
		return display.font_open_name(screen, name);
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
}
