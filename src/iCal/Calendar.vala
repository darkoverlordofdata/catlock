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
public errordomain CalendarException {
	InvalidCalendarNode	 
}

/**
 * Load calendar from an ICS file 
 */
public class ICal.Calendar : Object
{
	public string version = "";      	//  VERSION:2.0
	public string prodid = "";       	//  PRODID:icalendar-ruby
	public string calscale = "";     	//  CALSCALE:GREGORIAN
	public string calname = "";      	//  X-WR-CALNAME:US Holidays
	public string language = "";     	//  X-APPLE-LANGUAGE:en-US
	public string region = "";       	//  X-APPLE-REGION:US
	public string str = "";
	public GenericArray<EventNode> events = new GenericArray<EventNode>(200);//

	/**
	 * parse the calender from path
	 */
	public Calendar(string path) {
		string s0;
		string[] content;

		try {
			FileUtils.get_contents(path, out s0);
		}
		catch (GLib.FileError e) {
			print(@"Error: $(e.message)\n");
			Process.exit(1);
		}

		// clean up the raw data:
		try {
			var s1 = /\r\n /.replace(s0, -1, 0, "");	// unfold description 
			var s2 = /\\\; /.replace(s1, -1, 0, " ");	// remove slash-semicolon
			var s3 = /\\, /.replace(s2, -1, 0, " ");	// remove slash-comma
			content = s3.split("\r\n");
		}
		catch (GLib.RegexError e) {
			print(@"Error: $(e.message)\n");
			Process.exit(1);
		}
		int count = content.length-1;
		CalendarNode[] nodes = new CalendarNode[count];
		try {
			for (int i=0; i<count; i++) {
				nodes[i] = new CalendarNode(content[i]);
			}
		}
		catch (CalendarException.InvalidCalendarNode e) {
			print(@"Error: $(e.message)\n");
			Process.exit(1);
		}

		EventNode? event = null;
		int level = 0;

		for (int i=0; i<count; i++) {

			if ("BEGIN" == nodes[i].name) {
				level++;
				switch (level) {
					case 1:
						if ("VCALENDAR" == nodes[i].value) {
						}
						else Process.exit(99);
						break;
					case 2:
						if ("VEVENT" == nodes[i].value) {
							event = new EventNode();
							events.insert(events.length, event);
						}
						else Process.exit(99);
						break;

				}
				continue;
			}
			else if ("END" == nodes[i].name) {
				switch (level) {
					case 1:
						if ("VCALENDAR" == nodes[i].value) {
						}
						else Process.exit(99);
						break;
					case 2:
						if ("VEVENT" == nodes[i].value) {
						}
						else Process.exit(99);
						break;
				}				
				level--;
				continue;
			}
			switch (level) {
				case 1:
					// "VERSION",          //:2.0
					if ("VERSION" == nodes[i].name) {
						version = nodes[i].value;
					}
					// "PRODID",           //:icalendar-ruby
					else if ("PRODID" == nodes[i].name) {
						prodid = nodes[i].value;
					}
					// "CALSCALE",         //:GREGORIAN
					else if ("CALSCALE" == nodes[i].name) {
						calscale = nodes[i].value;
					}
					// "X-WR-CALNAME",     //:US Holidays
					else if ("X-WR-CALNAME" == nodes[i].name) {
						calname = nodes[i].value;
					}
					// "X-APPLE-LANGUAGE", //:en-US
					else if ("X-APPLE-LANGUAGE" == nodes[i].name) {
						language = nodes[i].value;
					}
					// "X-APPLE-REGION",   //:US
					else if ("X-APPLE-REGION" == nodes[i].name) {
						region = nodes[i].value;
					}
					break;

				case 2:
					// "DTSTAMP",          //:20190531T224632Z
					if ("DTSTAMP" == nodes[i].name) {
						event.dtstamp = nodes[i].value;
					}
					// "UID",              //:c5bbb4ae-8dfd-33db-b3e0-4862c55e3ce7
					else if ("UID" == nodes[i].name) {
						event.uid = nodes[i].value;
					}
					// "DTSTART",          //;VALUE=DATE:20180704
					else if ("DTSTART" == nodes[i].name) {
						event.dtstart = nodes[i].value;
					}
					// "CLASS",            //:PUBLIC
					else if ("CLASS" == nodes[i].name) {
						event.klass = nodes[i].value;
					}
					// "SUMMARY",          //;LANGUAGE=en-US:Independence Day
					else if ("SUMMARY" == nodes[i].name) {
						event.summary = nodes[i].value;
					}
					// "TRANSP",           //:TRANSPARENT
					else if ("TRANSP" == nodes[i].name) {
						event.transp = nodes[i].value;
					}
					// "RRULE",            //:FREQ=YEARLY;COUNT=5
					else if ("RRULE" == nodes[i].name) {
						event.rrule = nodes[i].param;
					}
					// "CATEGORIES",       //:Holidays
					else if ("CATEGORIES" == nodes[i].name) {
						event.categories = nodes[i].value;
					}
					// "X-APPLE-UNIVERSAL-ID", //:f42c6443-488d-9756-925b-bf42f63a3348
					else if ("X-APPLE-UNIVERSAL-ID" == nodes[i].name) {
						event.id = nodes[i].value;
					}
					break;
			}
		}
	 }
 } 