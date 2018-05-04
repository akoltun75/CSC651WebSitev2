using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


/// Class that gets the code for symbols
public class StationSymbol
{
    private static String[] stations = { "Art Oehmcke", "Black River Falls", "Brule", "Gov.Thompson", "Kettle Moraine", "Lake Mills", "Lakewood", "Langlade", "Les Voigt", "Nevin", "Osecola", "St.Croix Falls", "Wild Rose" };

    private static String[] stationSymbols = { "AO", "BRF", "BR", "GT", "KM", "LM", "LW", "LG", "LV", "NV", "OS", "SC", "WR" };

    //Returns the corresponding station symbol
    public static String getSymbol(String stationName)
    {
        int index = Array.IndexOf(stations, stationName);
        if (index < 0)
            return null;
        else
            return stationSymbols[Array.IndexOf(stations, stationName)];
    }

}