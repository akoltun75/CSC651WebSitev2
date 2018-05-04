using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// ADO.NET object that connects to lot history table
public class LotHistoryDataConnector:Connector
{
    String conString;
    public LotHistoryDataConnector():base()
    {
        //
        // TODO: Add constructor logic here
        //
        base.setConnectionString("Data Source=cscsql2.carrollu.edu;Initial Catalog=csc550_fall2016_akoltun;Persist Security Info=True;User ID=csc550_fall2016_akoltun;Password=480772");
   
    }
    //Update a month of lot history  
    public void executeUpdateLotHistory(string fieldName, object value, int monthsRecorded, string lotCode)
    {
        base.executeUpdate("ST_Lot_History_Data", fieldName, value, "Months_Recorded = " + monthsRecorded + " and Lot_Number = " + lotCode);
    }

}