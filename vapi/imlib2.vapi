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
	[CCode (cname = "Imlib_Border")]
	public class Border {
		public int left;
		public int right;
		public int top;
		public int bottom;
	}

	[Compact]
	[CCode (cname = "Imlib_Color")]
	public class Color {
		public int r;
		public int g;
		public int b;
	}

	[Compact]
	[CCode (cname = "Imlib_Color_Modifier")]
	public class ColorModifier {
		public int gamma;
		public int brightness;
		public int contrast;
	}
	
	[Compact]
	[CCode (cname = "Imlib_Image", free_function = "")]
	public class Image {
		public int rgb_width;
		public int rgb_height;
		public uchar* rgb_data;
		public uchar* alpha_data;
		public string filename;

		[CCode (cname = "imlib_load_image")]
		public static Image create_from_file(string filename);

		[CCode (cname = "imlib_context_set_image")]
		public void set_context();
	}

	[CCode (cname = "imlib_image_get_width")]
	public static int image_get_width();

	[CCode (cname = "imlib_image_get_height")]
	public static int image_get_height();

	[CCode (cname = "imlib_context_set_drawable")]
	public static void context_set_drawable(X.Pixmap pixmap);

	[CCode (cname = "imlib_render_image_on_drawable")]
	public static void render_image_on_drawable(int x, int y);

	[CCode (cname = "imlib_context_set_dither")]
	public static void context_set_dither(int dither);

	[CCode (cname = "imlib_context_set_display")]
	public static void context_set_display(X.Display display);

	[CCode (cname = "imlib_context_set_visual")]
	public static void context_set_visual(X.Visual visual);

 } 