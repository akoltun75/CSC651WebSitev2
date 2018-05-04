<%@ Page Language="C#" MasterPageFile="~/Site.master" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent"  runat="server">
    <%@ Import Namespace="ModelClasses" %> 
<script runat="server">
    
    ST_Lot_History_Data lotRecord;
    LotHistoryDataContext lotDataContext;
    ST_Stations_Lots stationRecord;
    StationLotDataContext stationContext;


    protected void Page_Load(object sender, EventArgs e)
    {

        //If the page is first loaded
        if (!Page.IsPostBack)
        {
         lotRecord = new ST_Lot_History_Data();
         lotDataContext = new LotHistoryDataContext();
         stationRecord = new ST_Stations_Lots();
         stationContext = new StationLotDataContext();


            //Redirect if user is not logged in
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
                Response.Redirect("MainPage.aspx");
            //Populate the lists

            populateLotList();
            populateMonthList();
            populateYearList();
            //Bind if there is a list to be selected
            populateGrid();

        }

    }


    //Populate the lot list
    private void populateLotList()
    {
        //Command for getting the lot number
        var stationLots = stationContext.ST_Stations_Lots.Where(record=>record.Station==StationList.Text);

        //No lot preference option
        LotList.Items.Add("No Lot Preference");
        //Add the different lot numbers
        foreach (var lot in stationLots)
            LotList.Items.Add(lot.Lot_Number);
    }
    //When the station list is selected, repopulate the lot and month lists, and then grid
    protected void StationList_SelectedIndexChanged(object sender, EventArgs e)
    {
        LotList.Items.Clear();
        populateLotList();
        MonthList.Items.Clear();
        populateMonthList();
        populateGrid();
    }
    //Populate the month list
    private void populateMonthList()
    {
        //Add a no month preference option
        MonthList.Items.Add("No Month Preference");
        var cycles = lotDataContext.ST_Lot_History_Data.Where(record => record.Lot_Number == LotList.Text);
        //Add the different months
        foreach (var cycle in cycles)
            MonthList.Items.Add(cycle.Month);


    }
    //Populate the year list
    private void populateYearList()
    {
        //Add the no minimum year option and years 2010 through 2020 
        MinYearList.Items.Add("No Minimum Year");
        for (int year = 2010; year <= 2020; year++)
            MinYearList.Items.Add("" + year);
        //Add the no maximum year option and years 2010 through 2020 
        MaxYearList.Items.Add("No Maximum Year");
        for (int year = 2010; year <= 2020; year++)
            MaxYearList.Items.Add("" + year);
    }

    //When the lot list is selected
    protected void LotList_SelectedIndexChanged(object sender, EventArgs e)
    {
        MonthList.Items.Clear();
        populateMonthList();
        populateGrid();
    }
    //Populate the grid
    private void populateGrid()
    {
        //If there are any lots to slect
        if (!LotList.Text.Trim().Equals(""))
        {
          
            var lotDataSet = (from r1 in lotDataContext.ST_Lot_History_Data.ToList()
                              from r2 in stationContext.ST_Stations_Lots.ToList()
                              where r1.Lot_Number==r2.Lot_Number && r2.Station==StationList.Text && lotEqualsCondition(r1) && monthEqualsCondition(r1) && minYearCondition(r1) && maxYearCondition(r1) orderby Int32.Parse(r2.Initial_feeding_date.Substring(r2.Initial_feeding_date.Length-4,4)),r1.Lot_Number select r1
                                 ).ToList();


             //Select the rows of lot history for the selected station
             //Load the table
            MainGridView.DataSource = lotDataSet;
            MainGridView.DataBind();
        }
        //Otherwise bind the table to nothing
        else
        {
            MainGridView.DataSource = null;
            MainGridView.DataBind();
        }
    }
    //
    private bool lotEqualsCondition(ST_Lot_History_Data monthRecord)
    {
        if (!LotList.Text.Equals("No Lot Preference"))
            return monthRecord.Lot_Number == LotList.Text;

        else
            return true;
    }


    private bool monthEqualsCondition(ST_Lot_History_Data monthRecord)
    {
        if (!MonthList.Text.Equals("No Month Preference"))
            return monthRecord.Month == MonthList.Text;
        else
            return true;
    }


    private bool minYearCondition(ST_Lot_History_Data monthRecord)
    {

        if (!MinYearList.Text.Equals("No Minimum Year"))
            return Int32.Parse(monthRecord.Month.Substring(monthRecord.Month.Length-4, 4)) >= Int32.Parse(MinYearList.Text);
        else
            return true;
    }


    private bool maxYearCondition(ST_Lot_History_Data data)
    {


        if (!MaxYearList.Text.Equals("No Maximum Year"))
            return Int32.Parse(data.Month.Substring(data.Month.Length-4, 4)) <= Int32.Parse(MinYearList.Text);
        else
            return true;
    }
    //When the minimum year list is selected
    protected void MinYearList_SelectedIndexChanged(object sender, EventArgs e)
    {
        populateGrid();
    }
    //When the maximum year list is selected
    protected void MaxYearList_SelectedIndexChanged(object sender, EventArgs e)
    {
        populateGrid();
    }
    //When the month list is selected
    protected void MonthList_SelectedIndexChanged(object sender, EventArgs e)
    {
        populateGrid();
    }


</script>
<div style="background-color:aqua;" class="text-center">
    
         
         <div class="text-center">
    
         
         Station
        <asp:DropDownList ID="StationList" runat="server" style="margin-left: 0px" OnSelectedIndexChanged="StationList_SelectedIndexChanged" AutoPostBack="True">
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
&nbsp;&nbsp;&nbsp; Lot Number<asp:DropDownList ID="LotList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="LotList_SelectedIndexChanged">
        </asp:DropDownList>
             &nbsp;Month List
             <asp:DropDownList ID="MonthList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="MonthList_SelectedIndexChanged">
             </asp:DropDownList>
             <br />
             Min Year
             <asp:DropDownList ID="MinYearList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="MinYearList_SelectedIndexChanged">
             </asp:DropDownList>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Max Year
             <asp:DropDownList ID="MaxYearList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="MaxYearList_SelectedIndexChanged">
             </asp:DropDownList>
        <br />
       
        
       
         </div>
       
        
       
        <asp:GridView ID="MainGridView" AutoGenerateColumns="true" runat="server" BackColor="White">
        </asp:GridView>
         <p style="text-align: center">
             <asp:HyperLink ID="HyperLink1" NavigateUrl="~/GenerateReport.aspx" runat="server">Back to Generate Reports Page</asp:HyperLink>
         </p>
    
</div>
</asp:Content>
