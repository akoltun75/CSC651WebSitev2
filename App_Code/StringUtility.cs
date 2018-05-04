using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
//String processing utility
    public class StringUtility
    {
        
        //Determines if a string is numeric
        public static bool isNumeric(String str)
        {
            double sampleVal = 0;
            decimal sampleVal1 = 0;
            int sampleVal2 = 0;
            float sampleVal3 = 0;
            return Double.TryParse(str, out sampleVal)||Decimal.TryParse(str, out sampleVal1)||Int32.TryParse(str,out sampleVal2)||float.TryParse(str,out sampleVal3);
        }

    //Determines if a string is an integer
    public static bool isInteger(String str)
    {
        int sampleVal1 = 0;
        return Int32.TryParse(str, out sampleVal1);
    }
}

    

