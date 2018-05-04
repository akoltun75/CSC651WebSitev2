<%@ Page Language="C#" MasterPageFile="~/Site.master" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
   <%@ Import Namespace="ModelClasses" %> 
    <script runat="server">
       StationLotDataContext stationContext;
        protected void Page_Load(object sender, EventArgs e)
        {
            //When the page first loads
            if (!Page.IsPostBack)
            {
                stationContext = new StationLotDataContext();
                //Redirect if user is not logged in
                if (!HttpContext.Current.User.Identity.IsAuthenticated)
                    Response.Redirect("MainPage.aspx");
                populateStationList();
                populateYearList();
            }


        }

        //Populate the station checkbox list
        private void populateStationList()
        {
            //Set the alignment of the checkbox list to horizontal
            StationCheckBoxList.RepeatDirection = RepeatDirection.Horizontal;
            //Add the different station names
            String[] stations = { "Art Oehmcke", "Black River Falls", "Brule", "Gov.Thompson", "Kettle Moraine", "Lake Mills", "Lakewood", "Langlade", "Les Voigt", "Nevin", "Osecola", "St.Croix Falls", "Wild Rose" };
            foreach (String str in stations)
            {
                StationCheckBoxList.Items.Add(str);
            }

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
        //Checks minimum year
        private bool minYearCondition(ST_Stations_Lots data)
    {

        if (!MinYearList.Text.Equals("No Minimum Year"))
            return Int32.Parse(data.Initial_feeding_date.Substring(data.Initial_feeding_date.Length-4, 4)) >= Int32.Parse(MinYearList.Text);
        else
            return true;
    }

    //Checks maximum year
    private bool maxYearCondition(ST_Stations_Lots data)
    {
        if (!MaxYearList.Text.Equals("No Maximum Year"))
            return Int32.Parse(data.Initial_feeding_date.Substring(data.Initial_feeding_date.Length-4, 4)) <= Int32.Parse(MinYearList.Text);
        else
            return true;
    }

        //Populate the station list
        private void populateGrid()
        {
            int selectedCount = 0;
            List<String> checkedStations = new List<string>();
            //Get all the checked stations
            for(int i=0;i<StationCheckBoxList.Items.Count;i++){
                if (StationCheckBoxList.Items[i].Selected)
                {
                    checkedStations.Add(StationCheckBoxList.Items[i].Text);
                   selectedCount++;
                }
            }

            var stationLotDataSet = (
                              from r1 in stationContext.ST_Stations_Lots.ToList() 
                              where  minYearCondition(r1) && maxYearCondition(r1) && checkedStations.Contains(r1.Station)  orderby r1.Station, Int32.Parse(r1.Initial_feeding_date.Substring(r1.Initial_feeding_date.Length-4,4)) select r1
                                 ).ToList();
            //If any of the boxes have been selected
            if (selectedCount > 0)
            {
                //Load the table with the data

                MainGridView.DataSource = stationLotDataSet;
                MainGridView.DataBind();
                MainGridView.Visible = true;
            }
            //Otherwise disconnect the data source
            else
            {
                MainGridView.DataSource = null;
                MainGridView.DataBind();
            }
        }
        //When another box is selected
        protected void StationCheckBoxList_SelectedIndexChanged(object sender, EventArgs e)
        {
            populateGrid();
        }
        //Whenever the minimum year list menu is selected
        protected void MinYearList_SelectedIndexChanged(object sender, EventArgs e)
        {
            populateGrid();
        }
        //Whenever the maximum year list menu is selected
        protected void MaxYearList_SelectedIndexChanged(object sender, EventArgs e)
        {
            populateGrid();
        }
    </script>
<div style="background-color:aqua;">
    <div style="text-align: center">
    
        List of Stations&nbsp;<asp:CheckBoxList ID="StationCheckBoxList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="StationCheckBoxList_SelectedIndexChanged">
        </asp:CheckBoxList>
        </div>
        <div style="text-align: center">

            Minimum

            Year&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="MinYearList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="MinYearList_SelectedIndexChanged">
            </asp:DropDownList>
            &nbsp;&nbsp;Maximum Year&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="MaxYearList" runat="server" Height="16px" AutoPostBack="True" OnSelectedIndexChanged="MaxYearList_SelectedIndexChanged">
            </asp:DropDownList>
            &nbsp;
            <asp:GridView ID="MainGridView" runat="server" AutoGenerateColumns="True" BackColor="White" BorderColor="Black">
            </asp:GridView>

        </div>
        <p style="text-align: center">
            <asp:HyperLink ID="HyperLink1" NavigateUrl="~/GenerateReport.aspx"  runat="server">Back to Generate Report Page</asp:HyperLink>
        </p>
    
</div>
</asp:Content>
