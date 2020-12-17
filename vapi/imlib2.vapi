/* imlib2.vapi
 *
 * Copyright (C) 2020 darkoverlordofdata
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Authors:
 * bruce davidson <darkoverlordofdata@gmail.com>
 */

 [CCode (cprefix = "", lower_case_cprefix = "", cheader_filename = "Imlib2.h")]
 namespace Imlib2 
 {

	[Compact]
	[CCode (free_function = "")]
	public class Imlib_Image { }

	public static Imlib_Image imlib_load_image(string filename);
	public static int imlib_context_set_image(Imlib_Image image);
	public static int imlib_image_get_width();
	public static int imlib_image_get_height();
	public static void imlib_context_set_drawable(X.Pixmap pixmap);
	public static void imlib_render_image_on_drawable(int x, int y);
	public static void imlib_context_set_dither(int dither);
	public static void imlib_context_set_display(X.Display display);
	public static void imlib_context_set_visual(X.Visual visual);

 } 