<%@ Page Language="C#" MasterPageFile="~/Site.master"%>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<%@ import Namespace="ModelClasses" %>
<script runat="server">
    ST_Lot_History_Data lotData;
    LotHistoryDataContext lotDataContext;
    StationLotDataContext stationContext;
    ST_Stations_Lots stationData;

    protected void Page_Load(object sender, EventArgs e)
    {
        //When the page first loads
        if (!Page.IsPostBack)
        {
           lotData = new ST_Lot_History_Data();
     lotDataContext = new LotHistoryDataContext();
            stationContext = new StationLotDataContext();
            stationData = new ST_Stations_Lots();

            //If user is not an admin, they should be redirected to the main page
            if(!HttpContext.Current.User.Identity.IsAuthenticated)
                Response.Redirect("MainPage.aspx");
            //Otherwise populate lists
            populateDayList();
        }

    }
    //Set the station lot values
    private void setStationLotValues()
    {
          stationData = new ST_Stations_Lots();
        stationData.Station = FirstFedStationList.Text;
        stationData.Species = SpeciesTextBox.Text;
        stationData.Strain = StrainTextBox.Text;
        stationData.DomesticStatus = DomesticList.Text;
        stationData.Initial_feeding_date = (MonthList.Text + " " + DayList.Text + "," + YearList.Text);
        stationData.First_Hatched_Station = FirstHatchedStationList.Text;
        stationData.Incubation_Hatchery_Station = IncubationHatcheryList.Text;
        stationData.Eggs_Source_Station = EggSourceStationList.Text;
    }

    //Inserts a lot record into the main station lots table
    private void insertLotRecord()
    {
        stationContext.ST_Stations_Lots.Add(stationData);
        stationContext.SaveChanges();
    }

    //Validation method
    private bool checkAllFields()
    {
        bool inProperFormat = true;
        String alertString = "";
        //If the corresponding lot code to the user's input already exists or the lot code is null

        if (SpeciesTextBox.Text.Trim().Equals("") || StrainTextBox.Text.Trim().Equals(""))
        {
            inProperFormat = false;
            alertString += "alert('This is not a valid lot number');";
        }
        else
        {
            stationData.Lot_Number = stationData.generateLotCode();
            if (stationContext.ST_Stations_Lots.Find(stationData.Lot_Number) != null)
            {
                inProperFormat = false;
                alertString += "alert('Lot number already exists');";
            }
        }
        //If there is no species entered or the species entered is not valid
        if (SpeciesTextBox.Text.Trim().Equals("")||!SpeciesValidator.isValidSpecies(SpeciesTextBox.Text))
        {
            inProperFormat = false;
            alertString+= "alert('Need to have an actual species name entered');";
        }
        //If there is no species entered or the species entered is not valid
        if (StrainTextBox.Text.Trim().Equals(""))
        {
            inProperFormat = false;
            alertString += "alert('Need to have a strain entered');";
        }
        //If the initial length entered is not numeric
        if (!StringUtility.isNumeric(InitialLengthBox.Text))
        {
            inProperFormat = false;
            alertString+= "alert('Need to have an actual number for the length');";
        }
        //If the initial weight entered is not numeric
        if (!StringUtility.isNumeric(InitialWeightBox.Text))
        {
            inProperFormat = false;
            alertString+= "alert('Need to have an actual number for the weight');";
        }
        //If the initial number of fish/eggs is not an integer
        if (!StringUtility.isInteger(InitialFishNumberBox.Text))
        {
            inProperFormat = false;
            alertString += "alert('Need to have an actual number for integer of eggs on hand');";
        }
        //If the initial length is not positive
        if (StringUtility.isNumeric(InitialLengthBox.Text) && Decimal.Parse(InitialLengthBox.Text) <=0)
        {
            inProperFormat = false;
            alertString += "alert('Length needs to be above zero');";
        }
        //If the initial weight is not positive
        if (StringUtility.isNumeric(InitialWeightBox.Text) && Decimal.Parse(InitialWeightBox.Text) <=0)
        {
            inProperFormat = false;
            alertString += "alert('Weight needs to be above zero');";
        }
        //If the initial number of fish/eggs is not positive
        if (StringUtility.isNumeric(InitialFishNumberBox.Text)&&Decimal.Parse(InitialFishNumberBox.Text)<=0)
        {
            inProperFormat = false;
            alertString += "alert('Number of eggs on hand needs to be above zero');";
        }
        //Constructs the alert string
        if (!inProperFormat)
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "alert", alertString, true);


        return inProperFormat;
    }


    //When the insert button is clicked
    protected void InsertButton_Click(object sender, EventArgs e)
    {
      
        setStationLotValues();
        if (!checkAllFields())
            return;

        insertLotRecord();
        setUpNewLotCycle();
        clearFields();

    }
    //Clears all the text boxes
    private void clearFields()
    {
        SpeciesTextBox.Text="";
        StrainTextBox.Text = "";
        InitialLengthBox.Text = "";
        InitialWeightBox.Text = "";
        InitialFishNumberBox.Text = "";
        DayList.Items.Clear();
        populateDayList();
        MonthList.SelectedIndex = 0;
        YearList.SelectedIndex = 0;
        DayList.SelectedIndex = 0;
        EggSourceStationList.SelectedIndex = 0;
        IncubationHatcheryList.SelectedIndex = 0;
        FirstFedStationList.SelectedIndex = 0;
        FirstHatchedStationList.SelectedIndex = 0;
        DomesticList.SelectedIndex = 0;
    }


    //Sets up the new lot cycle by setting up the first three rows of lot history
    private void setUpNewLotCycle()
    {
        //Set up selected date and lot code
        DateTime selectedDate = new DateTime(Int32.Parse(YearList.Text),MonthList.SelectedIndex+1,DayList.SelectedIndex+1);
        setFirstRow();
        setSecondRow();
        setThirdRow();
    }
    //Set the first row
    private void setFirstRow()
    {
        lotData = new ST_Lot_History_Data();
        lotData.Lot_Number = stationData.Lot_Number;
        lotData.Months_Recorded = 1;
        lotData.Month = CalendarUtility.prevMonthString(MonthList.Text+"'"+YearList.Text,3);
        lotData.Num_eggs_on_hand = Int32.Parse(InitialFishNumberBox.Text);
        lotData.Eggs_on_hand_weight= 0;
        lotData.Num_Mortalities = 0;
        lotData.Inv_adj_num = 0;
        lotData.Eggs_spawned_num = Int32.Parse(InitialFishNumberBox.Text);
        lotData.Eggs_pick_off_num = 0;
        lotData.Num_eggs_trans_in = 0;
        lotData.Eggs_trans_in_weight = 0;
        lotData.Num_eggs_trans_out = 0;
        lotData.Eggs_trans_in_weight = 0;
        lotData.Fish_stocked_num = 0;
        lotData.Fish_stocked_weight = 0;
        lotData.Feed_Type_A = "";
        lotData.Feed_Type_B = "";
        lotData.Amount_Fed_A = 0;
        lotData.Amount_Fed_B = 0;
        lotData.Unit_Price_Fed_A = 0;
        lotData.Unit_Price_Fed_B = 0;
        lotData.Length_on_last_day_of_month = 0;
        lotData.Num_of_days_feed_per_month = 0;
        lotData.Comments = "";
        lotDataContext.ST_Lot_History_Data.Add(lotData);
        lotDataContext.SaveChanges();
    }
    //Set the second row
    private void setSecondRow()
    {
        lotData = new ST_Lot_History_Data();
        lotData.Lot_Number = stationData.Lot_Number;
        lotData.Months_Recorded = 2;
        lotData.Month = CalendarUtility.prevMonthString(MonthList.Text+"'"+YearList.Text,2);
        lotData.Num_eggs_on_hand = Int32.Parse(InitialFishNumberBox.Text);
        lotData.Eggs_on_hand_weight= 0;
        lotData.Num_Mortalities = 0;
        lotData.Inv_adj_num = 0;
        lotData.Eggs_spawned_num = 0;
        lotData.Eggs_pick_off_num = 0;
        lotData.Num_eggs_trans_in = 0;
        lotData.Eggs_trans_in_weight = 0;
        lotData.Num_eggs_trans_out = 0;
        lotData.Eggs_trans_in_weight = 0;
        lotData.Fish_stocked_num = 0;
        lotData.Fish_stocked_weight = 0;
        lotData.Feed_Type_A = "";
        lotData.Feed_Type_B = "";
        lotData.Amount_Fed_A = 0;
        lotData.Amount_Fed_B = 0;
        lotData.Unit_Price_Fed_A = 0;
        lotData.Unit_Price_Fed_B = 0;
        lotData.Length_on_last_day_of_month = 0;
        lotData.Num_of_days_feed_per_month = 0;
        lotData.Comments = "";
        lotDataContext.ST_Lot_History_Data.Add(lotData);
        lotDataContext.SaveChanges();
    }
    //Set the third row
    private void setThirdRow()
    {
        lotData = new ST_Lot_History_Data();
        lotData.Lot_Number = stationData.Lot_Number;
        lotData.Months_Recorded = 3;
        lotData.Month =  lotData.Month = CalendarUtility.prevMonthString(MonthList.Text+"'"+YearList.Text,1);
        lotData.Num_eggs_on_hand = Int32.Parse(InitialFishNumberBox.Text);
        lotData.Eggs_on_hand_weight= Int32.Parse(InitialWeightBox.Text);
        lotData.Num_Mortalities = 0;
        lotData.Inv_adj_num = 0;
        lotData.Eggs_spawned_num = 0;
        lotData.Eggs_pick_off_num = 0;
        lotData.Num_eggs_trans_in = 0;
        lotData.Eggs_trans_in_weight = 0;
        lotData.Num_eggs_trans_out = 0;
        lotData.Eggs_trans_in_weight = 0;
        lotData.Fish_stocked_num = 0;
        lotData.Fish_stocked_weight = 0;
        lotData.Feed_Type_A = "";
        lotData.Feed_Type_B = "";
        lotData.Amount_Fed_A = 0;
        lotData.Amount_Fed_B = 0;
        lotData.Unit_Price_Fed_A = 0;
        lotData.Unit_Price_Fed_B = 0;
        lotData.Length_on_last_day_of_month = 0;
        lotData.Num_of_days_feed_per_month = 0;
        lotData.Comments = "";
        lotDataContext.ST_Lot_History_Data.Add(lotData);
        lotDataContext.SaveChanges();
    }
    //Populate the day list
    private void populateDayList()
    {
        int numDays=CalendarUtility.numDaysInMonth(MonthList.Text+"'"+YearList.Text);

        for (int i = 1; i <= numDays; i++)
            DayList.Items.Add(""+i);
    }
    //When the user selects the month list
    protected void MonthList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DayList.Items.Clear();
        populateDayList();
    }
    //When the user selects the year list
    protected void YearList_SelectedIndexChanged(object sender, EventArgs e)
    {
        DayList.Items.Clear();
        populateDayList();
    }
</script>


<div style="background-color:aqua; align-content:center;">
    
    <div style="text-align: center">
            
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
            
        Egg Source
            
        <asp:DropDownList ID="EggSourceStationList" runat="server">
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
            
        &nbsp;Incubation Hatchery
        <asp:DropDownList ID="IncubationHatcheryList" runat="server">
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
&nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; First Hatched Station
        <asp:DropDownList ID="FirstHatchedStationList" runat="server">
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
        &nbsp; First Fed Station
        <asp:DropDownList ID="FirstFedStationList" runat="server">
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
        Domestic or feral?
        <asp:DropDownList ID="DomesticList" runat="server">
             <asp:ListItem>Domestic</asp:ListItem>
        <asp:ListItem>Feral</asp:ListItem>
        </asp:DropDownList>
        <br />
            
        <br />
        <asp:Label ID="SpeciesLabel" runat="server" Text="Label">Species</asp:Label>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="SpeciesTextBox" runat="server" Width="190px"></asp:TextBox>
            
        <br />
        Strain&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="StrainTextBox" runat="server" Width="192px"></asp:TextBox>
            
        <br />
        Initial Length&nbsp;
        <asp:TextBox ID="InitialLengthBox" runat="server" Width="190px"></asp:TextBox>
            
        <br />
        Initial Weight
        <asp:TextBox ID="InitialWeightBox" runat="server" Width="190px"></asp:TextBox>
            
        <br />
        &nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="InitialFishLabel" runat="server" style="margin-left:-130px;" Text="Initial Number of Fish on Hand"></asp:Label>
        &nbsp;
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
        <asp:TextBox ID="InitialFishNumberBox" runat="server" style="margin-left:-60px;" Width="190px"></asp:TextBox>
            
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Initial Feeding Date&nbsp;&nbsp; Month
        <asp:DropDownList ID="MonthList" runat="server" OnSelectedIndexChanged="MonthList_SelectedIndexChanged" AutoPostBack="True">
            <asp:ListItem>Jan</asp:ListItem>
            <asp:ListItem>Feb</asp:ListItem>
            <asp:ListItem>Mar</asp:ListItem>
            <asp:ListItem>Apr</asp:ListItem>
            <asp:ListItem>May</asp:ListItem>
            <asp:ListItem>Jun</asp:ListItem>
            <asp:ListItem>Jul</asp:ListItem>
            <asp:ListItem>Aug</asp:ListItem>
            <asp:ListItem>Sep</asp:ListItem>
            <asp:ListItem>Oct</asp:ListItem>
            <asp:ListItem>Nov</asp:ListItem>
            <asp:ListItem>Dec</asp:ListItem>
        </asp:DropDownList>
&nbsp; Day
        <asp:DropDownList ID="DayList" runat="server" Height="16px" Width="58px">
        </asp:DropDownList>
        Year
        <asp:DropDownList ID="YearList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="YearList_SelectedIndexChanged">
            <asp:ListItem>2010</asp:ListItem>
            <asp:ListItem>2011</asp:ListItem>
            <asp:ListItem>2012</asp:ListItem>
            <asp:ListItem>2013</asp:ListItem>
            <asp:ListItem>2014</asp:ListItem>
            <asp:ListItem>2015</asp:ListItem>
            <asp:ListItem>2016</asp:ListItem>
            <asp:ListItem>2017</asp:ListItem>
            <asp:ListItem>2018</asp:ListItem>
            <asp:ListItem>2019</asp:ListItem>
            <asp:ListItem>2020</asp:ListItem>
        </asp:DropDownList>
            
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="InsertButton" runat="server" Text="Insert" OnClick="InsertButton_Click" />
            
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:HyperLink ID="MainPageHyperLink" NavigateUrl="~/MainPage.aspx" runat="server" Font-Underline="True" ForeColor="#0033CC">Back to Main Page</asp:HyperLink>
&nbsp;
        
</asp:Content>
