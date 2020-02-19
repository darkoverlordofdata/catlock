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

 [CCode (cprefix = "", lower_case_cprefix = "", cheader_filename = "pwd.h,unistd.h,sys/types.h")]
 namespace User
 {

	[Compact]
	[CCode (cname = "struct passwd", free_function = "")]
	public class Passwd {
		[CCode (cname = "pw_name")]
		public string  name;		/* user name */
		[CCode (cname = "pw_passwd")]
		public string  passwd;		/* encrypted password */
		[CCode (cname = "pw_uid")]
		public int		uid;		/* user uid */
		[CCode (cname = "pw_gid")]
		public int		gid;		/* user gid */
		[CCode (cname = "pw_change")]
		public time_t	change;		/* password change time */
		[CCode (cname = "pw_class")]
		public string  cls;			/* user access class */
		[CCode (cname = "pw_gecos")]
		public string  gecos;		/* Honeywell login info */
		[CCode (cname = "pw_dir")]
		public string  dir;			/* home directory */
		[CCode (cname = "pw_shwll")]
		public string  shell;		/* default shell */
		[CCode (cname = "pw_expire")]
		public time_t	expire;		/* account expiration */		

		[CCode (cname = "getpwuid")]
		public static Passwd from_uid(int uid);

		[CCode (cname = "getpwnam")]
		public static Passwd from_name(string name);
	}

	[CCode (cname = "crypt")]
	public string crypt(string key, string salt);

	public int getuid();

	public int geteuid();

	public void endpwent();

	public int setgid(int gid);

	public int setuid(int uid);

 } 