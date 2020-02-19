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


public class Parameters
{
	public static int 		_verbosity = 0;
	public static bool 		_scrot = false;
	public static bool 		_calendar = false;
	public static bool 		_version = false ;
	public static string 	_as_user = "";
	public static string 	_font = "bitstream vera sans";
	public static string	_theme = "badabing";

	const OptionEntry[] options = {
		{ "verbosity", 	0, 0, OptionArg.INT, 	ref _verbosity, 	"verbose level", null },
		{ "scrot", 		0, 0, OptionArg.NONE, 	ref _scrot, 		"scrot screen capture", null },
		{ "calendar", 	0, 0, OptionArg.NONE, 	ref _calendar, 		"holiday calendar", null },
		{ "version", 	0, 0, OptionArg.NONE, 	ref _version, 		"version", null },
		{ "as_user", 	0, 0, OptionArg.STRING, ref _as_user, 		"as user", null },
		{ "font", 		0, 0, OptionArg.STRING, ref _font, 			"font", null },
		{ "theme", 		0, 0, OptionArg.STRING, ref _theme, 		"theme", null },
		{ null }
	};

	public int verbosity;
	public bool scrot;
	public bool calendar;
	public bool version;
	public string as_user;
	public string font;
	public string theme;
	/**
	 * Command line
	 *	 
	 *	Usage:
	 *	com.github.darkoverlordofdata.catlock [OPTION?]
	 *
	 *	Help Options:
	 *	-h, --help       Show help options
	 *
	 *	Application Options:
	 *	--verbosity      verbose level
	 *	--scrot          scrot screen capture
	 *	--calendar       holiday calendar
	 *	--as_user        as user
	 *	--font           font
	 *	--version        version
	 */
	public static int main(string[] args)
	{
		var parms = new Parameters(args);
		if (parms.version) 
			print(@"catlock, the cat proof screen lock. version $(CatLock.VERSION).\n");
		else
			new CatLock.MainWindow(parms);
		return 0;
	}

	public Parameters(string[] args) {
		/** get flags & options */
		try {
			var opt_context = new OptionContext();
			opt_context.set_help_enabled(true);
			opt_context.add_main_entries(options, null);
			opt_context.parse(ref args);
		} catch (OptionError e) {
			print("error: %s\n", e.message);
			print("Run '%s --help' to see a full list of available command line options.\n", args[0]);
			critical (e.message);
		}
		verbosity 	= _verbosity;
		scrot 		= _scrot;
		calendar 	= _calendar;
		version 	= _version;
		as_user 	= _as_user;
		font 		= _font;
		theme 		= _theme;
        if (verbosity > 0) {
			print(@"verbosity 	= $verbosity\n");
			print(@"scrot 		= $scrot\n");
			print(@"calendar 	= $calendar\n");
			print(@"version 	= $version\n");
			print(@"as_user 	= $as_user\n");
			print(@"font 		= $font\n");
			print(@"theme 		= $theme\n");
		} 
	}
}

void die(string message) {
	print("%s\n", message);
	Process.exit(1);
}