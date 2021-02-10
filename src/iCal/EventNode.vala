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
 * Calendar vevent an ICS file 
 */
public class ICal.EventNode : Object
{
	public string dtstamp = "";      //  DTSTAMP:20190531T224632Z
	public string uid = "";          //  UID:c5bbb4ae-8dfd-33db-b3e0-4862c55e3ce7
	public string dtstart = "";      //  DTSTART;VALUE=DATE:20180704
	public string klass = "";        //  CLASS:PUBLIC
	public string summary = "";      //  SUMMARY;LANGUAGE=en-US:Independence Day
	public string transp = "";       //  TRANSP:TRANSPARENT
	public string rrule = "";        //  RRULE:FREQ=YEARLY;COUNT=5
	public string categories = "";   //  CATEGORIES:Holidays
	public string id = "";           //  X-APPLE-UNIVERSAL-ID:f42c6443-488d-9756-925b-bf42f63a3348

	public EventNode() {}
	
	public string to_string() {
		return """EventNode:
	dtstamp = %s
	uid = %s
	dtstart = %s
	klass = %s
	summary = %s
	transp = %s
	rrule = %s
	categories = %s
	id = %s
""".printf(dtstamp, uid, dtstart, klass, summary, transp, rrule, categories, id);		
	}
} 