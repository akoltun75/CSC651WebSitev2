using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for LotCodeValidator
/// </summary>
public class LotCodeValidator
{
        //
        // TODO: Add constructor logic here
        //

        //Checks to see if a stations lots table already exists
    public static bool lotNumberExists(String lotNumber)
    {
        System.Data.DataTable lotTable = new LotHistoryDataConnector().loadedTable("Select Lot_Number FROM ST_Stations_Lots where Lot_Number = '" + lotNumber + "'");

        return lotTable.Rows.Count > 0;
    }

}