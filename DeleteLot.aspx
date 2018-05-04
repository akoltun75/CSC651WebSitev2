<%@ Page Language="C#" MasterPageFile="~/Site.master"%>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<%@ import Namespace="ModelClasses" %>
<script runat="server">
    //Context objects
    LotHistoryDataContext lotDataContext;
    StationLotDataContext stationContext;

    protected void Page_Load(object sender, EventArgs e)
    {
        //When the page first loads
        if (!Page.IsPostBack)
        {
     //Initialize data context objects
    lotDataContext = new LotHistoryDataContext();
    stationContext = new StationLotDataContext();
            //If the user is not an admin redirect, otherwise populate lists
            if ( !HttpContext.Current.User.Identity.IsAuthenticated||!HttpContext.Current.User.IsInRole("Admin"))
                Response.Redirect("MainPage.aspx");
            populateLotList();

        }

    }
    //Delete the record in the station lots table
    private void deleteStationLotRecord()
    {
        stationContext.ST_Stations_Lots.Remove(stationContext.ST_Stations_Lots.Find(LotList.Text));
        stationContext.SaveChanges();
    }

    //Delete the record in the station lots table
    private void deleteAllLotHistory()
    {
        var list = lotDataContext.ST_Lot_History_Data.Where(lotData => lotData.Lot_Number == LotList.Text);
        foreach (var monthRecord in list)
            lotDataContext.ST_Lot_History_Data.Remove(monthRecord);
        lotDataContext.SaveChanges();
    }

    
    //Populate the lot list
    private void populateLotList()
    {
      foreach (ST_Stations_Lots stationRecord in stationContext.ST_Stations_Lots.Where(record=>record.Station==StationList.Text))
        {
            LotList.Items.Add(stationRecord.Lot_Number);
        }
    }

    //When the delete button is clicked, delete the lot record, table, and functions
    protected void DeleteButton_Click(object sender, EventArgs e)
    {
        if (LotList.Items.Count == 0)
        {
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "alert", "alert('There is no valid lot cycle with which to delete');", true);
            return;

        }
        deleteAllLotHistory();
        deleteStationLotRecord();
        LotList.Items.Clear();
        populateLotList();
    }
    //When the station list is selected
    protected void StationList_SelectedIndexChanged(object sender, EventArgs e)
    {
        LotList.Items.Clear();
        populateLotList();
    }
</script>



<div style="background-color:aqua">
    
    <div>
    
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Station&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:DropDownList ID="StationList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="StationList_SelectedIndexChanged">
         <asp:ListItem>Art Oehmcke</asp:ListItem>
        <asp:ListItem>Black River Falls</asp:ListItem>
        <asp:ListItem>Brule</asp:ListItem>
        <asp:ListItem>Gov.Thompson</asp:ListItem>
        <asp:ListItem>Kettle Moraine</asp:ListItem>
        <asp:ListItem>Lake Mills</asp:ListItem>
        <asp:ListItem>Lakewood</asp:ListItem>
        <asp:ListItem>Langlade</asp:ListItem>
        <asp:ListItem>Les Voigt</asp:ListItem>
        <asp:ListItem>Nevin</asp:ListItem>
        <asp:ListItem>Osecola</asp:ListItem>
        <asp:ListItem>St.Croix Falls</asp:ListItem>
        <asp:ListItem>Wild Rose</asp:ListItem>
        </asp:DropDownList>
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Lot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:DropDownList ID="LotList" runat="server">
        </asp:DropDownList>
    
        <br />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="DeleteButton" runat="server" Text="Delete Lot" OnClick="DeleteButton_Click" />
    
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:HyperLink ID="MainPageHyperLink" runat="server" NavigateUrl="~/MainPage.aspx" Font-Underline="True" ForeColor="#0033CC">Back to Main Page</asp:HyperLink>
    
    </div>
   
</div>
</asp:Content>
