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
 * Calendar from an ICS file 
 */

class ICal.CalendarNode : Object
{
	public string name = "";
	public string param = "";
	public string value = "";

	public CalendarNode(string str) throws CalendarException.InvalidCalendarNode {

		var c = (char*)str;
		var index = -1;
		for (var i=0; i<str.length; i++) {
			if (c[i] == ';' || c[i] == ':') {
				index = i;
				break;
			}
		}
		if (index < 0) throw new CalendarException.InvalidCalendarNode(str);
		name = str.substring(0, index);
		if (c[index] == ':') index += 1;

		
		var a = str.substring(index).split(":");
		if (a.length == 1) {
			if (a[0].index_of("=") > 0) {
				value = "";
				param = a[0];
			}
			else {
				value = a[0];
				param = "";
			} 
		}
		else {
			value = a[1];
			if (a[0].index_of("=") == 0) {
				param = a[0].substring(1);
			} 
			else {
				param = a[0];
			}
		}
	}

//  	public string to_string() {
//  		return """CalendarNode:
//  	name = %s
//  	value = %s
//  	param = %s
//  """.printf(name, value, param);		
//  	}
}
