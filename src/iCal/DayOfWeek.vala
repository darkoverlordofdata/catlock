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

namespace ICal 
{
    public enum DayOfWeek {
        Sunday = 0,
        Monday = 1,
        Tuesday = 2,
        Wednesday = 3,
        Thursday = 4,
        Friday = 5,
        Saturday = 6,
        UNKNOWN = -1;

        public string to_string() {
            switch (this) {
            case Sunday:    return "Sunday";
            case Monday:    return "Monday";
            case Tuesday:   return "Tuesday";
            case Wednesday: return "Wednesday";
            case Thursday:  return "Thursday";
            case Friday:    return "Friday";
            case Saturday:  return "Satuday";
            default: assert_not_reached();
            }
        }

        public static DayOfWeek parse(string day) {
            switch (day) {
            case "Sunday":    return Sunday;
            case "Monday":    return Monday;
            case "Tuesday":   return Tuesday;
            case "Wednesday": return Wednesday;
            case "Thursday":  return Thursday;
            case "Friday":    return Friday;
            case "Saturday":  return Saturday;

            case "SU":  return Sunday;
            case "MO":  return Monday;
            case "TU":  return Tuesday;
            case "WE":  return Wednesday;
            case "TH":  return Thursday;
            case "FR":  return Friday;
            case "SA":  return Saturday;

            default: return UNKNOWN;
            }
        } 

        public static DayOfWeek[] all() {
            return { Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday };
        }        

    }
}