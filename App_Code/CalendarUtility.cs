using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Globalization;

/// Class that handles specific date processing
public class CalendarUtility
{

    //Gives the month string in format mmm'yyyy for the  month, assumes monthStr is in format starting a three letter month symbol and ending in four digit year
    public static String prevMonthString(String monthStr, int numMonths)
    {
        DateTime prevDateTime = new GregorianCalendar().AddMonths(DateTime.Parse(monthStr.Substring(0, 3) + " " + 1 + "," + monthStr.Substring(monthStr.Length - 4, 4)), numMonths * -1);
        String monthPortion = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(prevDateTime.Month).Substring(0,3);
        return monthPortion + "'" + prevDateTime.Year;
    }
    //Gives the month string in format mmm'yyyy for the next month, assumes monthStr is in format starting a three letter month symbol and ending in four digit year
    public static String nextMonthString(String monthStr,int numMonths)
    {

        DateTime nextDateTime = new GregorianCalendar().AddMonths(DateTime.Parse(monthStr.Substring(0, 3) + " " + 1 + "," + monthStr.Substring(monthStr.Length - 4, 4)), numMonths);
        String monthPortion = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(nextDateTime.Month).Substring(0, 3);
        return monthPortion + "'" + nextDateTime.Year;

    }
    //Calculates the number of days given a month string, assumes monthStr is in format starting a three letter month symbol and ending in four digit year
    public static int numDaysInMonth(String monthStr)
    {
        DateTime initialDate = DateTime.Parse(monthStr.Substring(0,3)+" "+1+","+monthStr.Substring(monthStr.Length-4,4));
        GregorianCalendar cal = new GregorianCalendar();
        int initialNumDays = cal.GetDaysInMonth(cal.GetDayOfYear(initialDate), cal.GetDayOfMonth(initialDate)) - cal.GetDayOfMonth(initialDate);
        return initialNumDays;       
     }

}