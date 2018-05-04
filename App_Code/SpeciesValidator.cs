using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Class with method that connects to species reference table, uses ADO.NET like connector because there is no updating of, just connecting to the table
/// </summary>
public class SpeciesValidator
{
    //Search the species reference table to see if the inputted species is a valid name
    public static bool isValidSpecies(string speciesName)
    {
        System.Data.DataTable lotTable = new LotHistoryDataConnector().loadedTable("Select Fish_Cmmn_Name from ST_species_ref_table WHERE '" + speciesName + "' Like '%'+Fish_Cmmn_Name+'%'");
        return lotTable.Rows.Count > 0;
    }
}