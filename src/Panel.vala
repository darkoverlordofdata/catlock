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
* XWindow wrapper
*/
public class CatLock.Panel : GLib.Object 
{
	X.Window window;        // top level window

	/**
	*/
	public Panel(Display app, string imgfn) 
	{
		var image = Imlib2.Image.create_from_file(imgfn);
		image.set_context();
		int width = Imlib2.image_get_width();
		int height = Imlib2.image_get_height();

		if (app.panels.length > 1) {
			window = X.create_simple_window(app.display, app.window, 0, 0, width, height,
				0, app.fg.pixel, app.bg.pixel);
		}
		else window = app.window;

		/* Set the top level background image */
		var pixm = X.create_pixmap(app.display, window, width, height, app.depth);
		Imlib2.context_set_drawable(pixm);
		Imlib2.render_image_on_drawable(0, 0);

		X.set_window_background_pixmap(app.display, window, pixm);
		X.free_pixmap(app.display, pixm);

	}

}
 