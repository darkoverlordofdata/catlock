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
/**
 * Calendar rrule from an ICS file 
 */
public class CatLock.Rule : Object
{
	public string freq = "";         //  yearly
	public string count = "";        //  5
	public string byday = "";        //  byday
	public string bymonth = "";      //  bymonth
	public string[] array;


	public Rule(string str) {
		array = str.split_set("=;");
		//  print(@"$str\n");
		//  foreach (string s in array) print(@"$s  ");
		//  print("\n");

		for (int i = 0; i<array.length; i++) {
			/* FREQ Repeat (Yearly, Monthly, Weekly, Daily, Hourly) */
			if (array[i] == "FREQ")
				freq = array[i+1];

        	/* COUNT/UNTIL End (Never After:n On:date) */
			else if (array[i] == "COUNT")
				count = array[i+1];

        	/* BYDAY+SETPOS+BYMONTH OnThe (1st 2nd 3rd 4th Last;  Mon-Sun / Day/ Weekday/ WeekendDay) of (Jan-Dec) */
			else if (array[i] == "BYDAY")
				byday = array[i+1];
			
	        /* BYMONTH+BYMONTHDAY On (Jan - Dec; 1-31) */
			else if (array[i] == "BYMONTH")
				bymonth = array[i+1];
		}
		
	}

	public string to_string() {
		return """CalendarNode:
	freq = %s
	count = %s
	byday = %s
	bymonth = %s
""".printf(freq, count, byday, bymonth);		
	}

}