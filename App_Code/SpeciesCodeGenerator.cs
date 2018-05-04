using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// Class that connects to species table, uses ADO.NET like connector because there is no updating of, just connecting to the table
public class SpeciesCodeGenerator
{
    //Return the corresponding species code if it exists
    public static string getSpeciesCode(string speciesName)
    {
        System.Data.DataTable lotTable = new LotHistoryDataConnector().loadedTable("Select Fish_Species_Code, Fish_Cmmn_Name FROM ST_species_ref_table WHERE '" + speciesName + "' Like '%'+Fish_Cmmn_Name+'%' Order by LEN(Fish_Cmmn_Name) ");
        //If there is a corresponding species code
        if (lotTable.Rows.Count > 0)
            return lotTable.Rows[lotTable.Rows.Count - 1]["Fish_Species_Code"].ToString();
        else
            return null;
    }
}