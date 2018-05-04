using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data.Entity;
using System.Data;

/// <summary>
/// Summary description for Connector
/// </summary>
public class Connector
{
    private SqlConnection con;
    public Connector()
    {
        //
        // TODO: Add constructor logic here
        //
         }

    //Set the connection string
    public void setConnectionString(String conString)
    {
        con = new SqlConnection(conString);
    }

    //Creates a loaded table from the command
    public DataTable loadedTable(String command)
    {
        if (con == null)
            throw new Exception("Connection has to be set");

       SqlCommand lotCommand = new SqlCommand(command);
        lotCommand.Connection = con;
        DataTable lotTable = new DataTable();
        con.Open();
        lotTable.Load(lotCommand.ExecuteReader());
        con.Close();
        return lotTable;
    }
    //Execute an insert command
    public void executeInsert(string tableName, string[] parameters,object[] values)
    {
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = con;
        con.Open();
        string cmdStringPt1 = "Insert into "+tableName+"(";
        string cmdStringPt2 = ") Values(";
        //cmd.CommandText = "Insert into ST_Stations_Lots() Values()";
        var recordPairs = parameters.Zip(values, (p, v) => new { Param = p, Value = v });
      foreach(var record in recordPairs){
            cmdStringPt1 += record.Param+",";
            cmdStringPt2 += "'"+record.Value + "',";
        }
        cmd.CommandText = cmdStringPt1.Substring(0, cmdStringPt1.Length - 1)+cmdStringPt2.Substring(0,cmdStringPt2.Length-1)+")";
        cmd.ExecuteNonQuery();
        con.Close();
    }
    //Execute an update command
    public void executeUpdate(string tableName,string fieldName,object value,string whereConditions)
    {
        SqlCommand cmd = new SqlCommand();
        con.Open();
        cmd.Connection = con;
        cmd.CommandText = "Update " + tableName + " Set " + fieldName + " = " + value + " Where " + whereConditions; 
        cmd.ExecuteNonQuery();
        con.Close();
    }
    //Execute a delete command
    public void executeDelete(string tableName, string whereConditions)
    {
        SqlCommand cmd = new SqlCommand();
        con.Open();
        cmd.Connection = con;
        cmd.CommandText = "Delete From " + tableName +" Where " + whereConditions;
        cmd.ExecuteNonQuery();
        con.Close();
    }
}