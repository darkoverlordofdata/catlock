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

namespace CatLock 
{
	/**
	* last_dayofmonth
	* 
	* @param year
	* @param month
	* @returns day number (0-6)
	*/
	int last_dayofmonth(int y, int m) {
		//             jan feb mar apr may jun jul aug sep oct nov dec
		int[] d = { 0,  31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
		d[2] = (y%100==0 ? y%4==0 ? false : true : y%400==0 ? false : true) ? 29 : 28;
		return d[m];
	}
	
	/**
	* dayofweek
	* 
	* @param year
	* @param month
	* @param day
	* @returns day number (0-6)
	*/
	int dayofweek(int y, int m, int d) 
	{ 
		int[] t = { 0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4 }; 
		y -= (int)(m < 3); 
		return ( y + y/4 - y/100 + y/400 + t[m-1] + d) % 7; 
	} 
} 

public class CatLock.Holiday : Object
{
	 public Holiday next;       		//  next => in list
	 public int date;            		//  vevent dtstart
	 public string description = ""; 	//  vevent summary

	 public string to_string() {
		return @"Holiday $date: $description";
	}
	 
}
  
/**
 * Load holidays fron ICS file 
 */
public class CatLock.Holidays : Object
{
	public List<Holiday> list = new List<Holiday>();
	public int today;           		//  today's date
	public int tomorrow;				// 	tomorrow's date
	public int count;           		//  count of holidays

	public Holidays() {
        var now = time_t();
		var t = GLib.Time.local(now);
		
		today = (1900+t.year)*10000 + (t.month+1)*100 + t.day;

		Date d = {};
		d.set_time_t(now);
		d.add_days(1);

		tomorrow = ((d.get_year())*10000 + (d.get_month())*100 + d.get_day());

	}
		
	public Holidays.from_path(string path) {
		this();
		var cal = new Calendar(path);
		Rule? rr;

		count = 0;
		for (int i=0; i<cal.events.length; i++) {
			/**
			* only consider entries with a YEARLY recurance rule
			*/
			if (cal.events[i].rrule != null) {
				if (cal.events[i].rrule.index_of("FREQ=YEARLY") > 0)
					count += 1;
			}
		}

		//  print(@"cal.events.length = $(cal.events.length)\n");
		for (int i=0; i<cal.events.length; i++) {
			if (cal.events[i].rrule != null) {
				//  print(@"RULE:$(cal.events[i].rrule)\n");
				rr = new Rule(cal.events[i].rrule);
				//  print(@" $(cal.events[i].dtstart) $(cal.events[i].rrule)\n");
				if ("YEARLY" != rr.freq) continue;

				int dtstart = int.parse(cal.events[i].dtstart);
				//  print(@"$(rr.to_string())\n");

				if (rr.byday != "" && rr.bymonth != "") {
					/**
				 	 * Holiday such as Memorial Day or MLK Birthday
					 * occur on the Nth Weekday of the month.
					 */
					bool searching = true;
					bool last;
					char byday;
					int ordinal;
					string dayname;

					if (rr.byday[0] == '-') {
						last = true;
						byday = rr.byday[1];
						ordinal = (int)byday-48;
						dayname = rr.byday.substring(2);
					} else {
						last = false;
						byday = rr.byday[0];
						ordinal = (int)byday-48;
						dayname = rr.byday.substring(1);
					}

					int yyyy = (today/10000) * 10000;
					int mm = int.parse(rr.bymonth);
			
					if (last) {
						/**
						* Look for Last Monday
						*/
						while (searching) {
			
							//  print(@"Look for last $dayname day of month\n");
							int last_day = last_dayofmonth(yyyy, mm);
							int offset = "SU.MO.TU.WE.TH.FR.SA.".index_of(dayname);
							if (offset < 0) break;
							int day = last_day - 7 * ordinal + offset;
							dtstart = yyyy + mm * 100 + day;
							if (dtstart < today) yyyy += 10000;
							else searching = false;
						}
					} else {
						/**
						* Look for Nth Monday
						*/
						while (searching) {
							//  print(@"Look for Nth $dayname day of month\n");
			
							int start_day = dayofweek(yyyy/10000, mm, 1);
							int offset = "SU.MO.TU.WE.TH.FR.SA.".index_of(dayname);
							if (offset < 0) break;
							int weeks;
							if (start_day == 0) 
								weeks = (7 * (ordinal-1)) + 1;
							else
								weeks = (7 * (ordinal)) + 1;
							int day = weeks - start_day + offset;
							dtstart = yyyy + mm * 100 + day;
			
							if (dtstart < today) yyyy += 10000;
							else searching = false;
						}
					}
							
				} 
				else {
					/**
					 * This is easy - holidays like New Years Day
					 * or 4th of July are always on the same date.
					 */
					while (dtstart < today) {
					   dtstart += 10000; //add 1 year
					}
				}
				/**
				* push holiday node onto list 
				*/
				Holiday new_node = new Holiday(); 
				new_node.description = cal.events[i].summary;
				new_node.date = dtstart;
				list.append(new_node);
			}
		}
	}

	public string[] today_is () {

		string[] result = {};

        list.foreach((entry) => {
			if (today == entry.date) {
				result.resize(result.length+1);
				result[result.length-1] = entry.description;
			}
        });

		return result;

	}

	public string[] tomorrow_is () {

		string[] result = {};
        list.foreach((entry) => {
			if (tomorrow == entry.date) {
				result.resize(result.length+1);
				result[result.length-1] = entry.description;
			}
        });

		return result;

	}
}

