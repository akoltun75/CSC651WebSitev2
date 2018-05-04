<%@ Page Language="C#" MasterPageFile="~/Site.master"  %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server" >
<%@ import NameSpace="ModelClasses" %>
<%@ import Namespace="System.Globalization" %>
<script runat="server">
    ST_Lot_History_Data[] lotTable;
    ST_Lot_History_Data lotData;
    LotHistoryDataContext lotContext;
    StationLotDataContext stationContext;
    ST_Stations_Lots stationData;
    protected void Page_Load(object sender, EventArgs e)
    {
        //If the page is first loaded, populate the lists
        if (!Page.IsPostBack)
        {
     //Initialize data objects
    lotData = new ST_Lot_History_Data();
     lotContext = new LotHistoryDataContext();
     stationContext = new StationLotDataContext();
    stationData = new ST_Stations_Lots();
    
            //If user is not an admin, they should be redirected to the main page
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
                Response.Redirect("MainPage.aspx");
            populateLotList();
            populateLotTable();
            enableSelectControls();
        }

    }
    //Populate the lot table
    private void populateLotTable()
    {
        lotTable = lotContext.ST_Lot_History_Data.Where(record=>record.Lot_Number==LotList.Text).ToArray();

    }

    //Populate the lot list
    private void populateLotList()
    {
        //Retrieve the lot number corresponding to the station

        var lotCycles = stationContext.ST_Stations_Lots.Where(data => data.Station == StationList.Text).ToArray();
        //Load all the lot numbers
        foreach (var lotCycle in lotCycles)
            LotList.Items.Add(lotCycle.Lot_Number);

    }

    //Method to perform validation
    private bool checkAllFields()
    {
        bool inProperFormat = true;
        String alertString = "";
        //If there is no valid lot cycle, reject immediately
        if (LotList.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "alert", "alert('There is no valid lot cycle with which to update');", true);
            return false;
        }

        //If the number of eggs on hand is not numeric
        if (!StringUtility.isInteger(NumEggsOnHandBox.Text))
        {
            inProperFormat = false;
            alertString += "alert('Need to have an actual integer for the number of eggs on hand');";
        }
        //If the number of eggs on hand is below zero
        if (StringUtility.isNumeric(NumEggsOnHandBox.Text) && Decimal.Parse(NumEggsOnHandBox.Text) <= 0)
        {
            inProperFormat = false;
            alertString += "alert('Number of eggs on hand needs to be above zero');";
        }
        //If the number of eggs on hand is more than the previous value
        if (StringUtility.isNumeric(NumEggsOnHandBox.Text) && Decimal.Parse(NumEggsOnHandBox.Text)>lotTable[lotTable.Length-1].Num_eggs_on_hand)
        {
            inProperFormat = false;
            alertString += "alert('Number of eggs on hand needs to be in proper order');";
        }
        //If the weight of eggs on hand is not numeric
        if (!StringUtility.isNumeric(WeightBox.Text))
        {
            inProperFormat = false;
            alertString += "alert('Need to have an actual number for the weight of the eggs on hand');";
        }
        //If the weight of eggs on hand is below zero
        if (StringUtility.isNumeric(WeightBox.Text) && Decimal.Parse(WeightBox.Text) <= 0)
        {
            inProperFormat = false;
            alertString += "alert('Weight of eggs on hand needs to be above zero');";
        }
        //If the mortality rate field has something entered in it but is not numeric
        if (!StringUtility.isInteger(MortalityRateBox.Text) && !MortalityRateBox.Text.Trim().Equals(""))
        {
            inProperFormat = false;
            alertString += "alert('Need to have an actual integer for the mortality rate');";
        }
        //If the mortality rate field has something entered in it but is below zero
        if (StringUtility.isNumeric(MortalityRateBox.Text) && Decimal.Parse(MortalityRateBox.Text) < 0)
        {
            inProperFormat = false;
            alertString += "alert('Mortality rate needs to be positive');";
        }
        //If the inventory adjustment field has something entered in it but is not numeric
        if (!StringUtility.isInteger(InventoryAdjustmentBox.Text) && !InventoryAdjustmentBox.Text.Trim().Equals(""))
        {
            inProperFormat = false;
            alertString += "alert('Need to have an actual integer for the inventory adjustment number');";
        }
        //If the number of eggs transferred in field has something entered in it but is not numeric
        if (!StringUtility.isInteger(EggsTransferredInNumBox.Text) && !EggsTransferredInNumBox.Text.Trim().Equals(""))
        {
            inProperFormat = false;
            alertString += "alert('Need to have an actual integer for the number of fish transferred in');";
        }
        //If the number of eggs transferred in field has something entered in it but is below zero
        if (StringUtility.isNumeric(EggsTransferredInNumBox.Text) && Decimal.Parse(EggsTransferredInNumBox.Text) <= 0)
        {
            inProperFormat = false;
            alertString += "alert('Number of fish transferred in needs to be above zero');";
        }
        //If the weight of eggs transferred in field has something entered in it but is not numeric
        if (!StringUtility.isNumeric(EggsTransferredInWeightBox.Text) && !EggsTransferredInWeightBox.Text.Trim().Equals(""))
        {
            inProperFormat = false;
            alertString += "alert('Need to have an actual number for the weight of fish transferred in');";
        }
        //If the weight of eggs transferred in field has something entered in it but is below zero
        if (StringUtility.isNumeric(EggsTransferredInWeightBox.Text) && Decimal.Parse(EggsTransferredInWeightBox.Text) <= 0)
        {
            inProperFormat = false;
            alertString += "alert('Weight of fish on transferred in needs to be positive');";
        }
        //If not both eggs transferred in quantities are both numeric
        if ((StringUtility.isNumeric(EggsTransferredInNumBox.Text) && !StringUtility.isNumeric(EggsTransferredInWeightBox.Text)) || (!StringUtility.isNumeric(EggsTransferredInNumBox.Text) && StringUtility.isNumeric(EggsTransferredInWeightBox.Text)))
        {
            inProperFormat = false;
            alertString += "alert('Both eggs transferred in quantities need to be numeric');";
        }
        //If the number of eggs transferred out field has something entered in it but is not an integer
        if (!StringUtility.isInteger(EggsTransferredOutNumBox.Text) && !EggsTransferredOutNumBox.Text.Trim().Equals(""))
        {
            inProperFormat = false;
            alertString += "alert('Need to have an actual integer of fish transferred out');";
        }
        //If the number of eggs transferred out field has something entered in it but below zero
        if (StringUtility.isNumeric(EggsTransferredOutNumBox.Text) && Decimal.Parse(EggsTransferredOutNumBox.Text) <= 0)
        {
            inProperFormat = false;
            alertString += "alert('Number of fish transferred out needs to be positive');";
        }
        //If the weight of eggs transferred out field has something entered in it but is not numeric
        if (!StringUtility.isNumeric(EggsTransferredOutWeightBox.Text) && !EggsTransferredOutWeightBox.Text.Trim().Equals(""))
        {
            inProperFormat = false;
            alertString += "alert('Need to have an actual number for the weight of fish transferred out');";
        }
        //If the weight of eggs transferred out field has something entered in it but is below zero
        if (StringUtility.isNumeric(EggsTransferredOutWeightBox.Text) && Decimal.Parse(EggsTransferredOutNumBox.Text) <= 0)
        {
            inProperFormat = false;
            alertString += "alert('Weight of fish transferred out needs to be above zero');";
        }
        //If not both eggs transferred out quantities are both numeric
        if ((StringUtility.isNumeric(EggsTransferredOutNumBox.Text) && !StringUtility.isNumeric(EggsTransferredOutWeightBox.Text)) || (!StringUtility.isNumeric(EggsTransferredOutNumBox.Text) && StringUtility.isNumeric(EggsTransferredOutWeightBox.Text)))
        {
            inProperFormat = false;
            alertString += "alert('Both eggs transferred out quantities need to be numeric');";
        }
        //If the number of fish stocked field has something entered in it but is not numeric
        if (!StringUtility.isInteger(FishStockedNumBox.Text) && !FishStockedNumBox.Text.Trim().Equals(""))
        {
            inProperFormat = false;
            alertString += "alert('Need to have an actual integer for the number of fish stocked');";
        }
        //If the number of fish stocked field has something entered in it but is below zero
        if (StringUtility.isNumeric(FishStockedNumBox.Text) && Decimal.Parse(FishStockedNumBox.Text) <= 0)
        {
            inProperFormat = false;
            alertString += "alert('Number of fish stocked needs to be above zero');";
        }
        //If the weight of fish stocked field has something entered in it but is not numeric
        if (!StringUtility.isNumeric(FishStockedWeightBox.Text) && !FishStockedWeightBox.Text.Trim().Equals(""))
        {
            inProperFormat = false;
            alertString += "alert('Need to have an actual number for the weight of fish stocked');";
        }
        //If the weight of fish stocked field has something entered in it but is below zero
        if (StringUtility.isNumeric(FishStockedWeightBox.Text) && Decimal.Parse(FishStockedWeightBox.Text) <=0)
        {
            inProperFormat = false;
            alertString += "alert('Weight of fish stocked out needs to be above zero');";
        }
        //If not both stock quantities are both numeric
        if ((StringUtility.isNumeric(FishStockedNumBox.Text)&& !StringUtility.isNumeric(FishStockedWeightBox.Text))|| (!StringUtility.isInteger(FishStockedNumBox.Text) && StringUtility.isNumeric(FishStockedWeightBox.Text)))
        {
            inProperFormat = false;
            alertString += "alert('Both fish stocked quantities need to be numeric');";
        }

        //If the cumulative length field has something entered in it but is not numeric
        if (!StringUtility.isNumeric(CumLengthBox.Text) && (!CumLengthBox.Text.Trim().Equals("")|| (Double)lotTable[lotTable.Length - 1].Length_on_last_day_of_month >= 9.5))
        {
            inProperFormat = false;
            alertString += "alert('Need to have an actual number for the cumulative box');";
        }
        //If the cumulative length field has something entered in it but is below zero
        if (StringUtility.isNumeric(CumLengthBox.Text) && Decimal.Parse(CumLengthBox.Text) <= 0)
        {
            inProperFormat = false;
            alertString += "alert('The cumulative length needs to be above zero');";
        }
        //If the cumulative length is longer than the previous value
        if (StringUtility.isNumeric(CumLengthBox.Text) && Decimal.Parse(CumLengthBox.Text) < lotTable[lotTable.Length-1].Length_on_last_day_of_month)
        {
            inProperFormat = false;
            alertString += "alert('Cumulative length needs to be in proper order');";
        }
        //If feed type a text box has nothing in it
        if (FeedTypeATextBox.Text.Equals(""))
        {
            inProperFormat = false;
            alertString += "alert('There needs to be values for feed type A');";

        }
        //If there are not numerical values for the amount or price of feed type A
        if (!FeedTypeATextBox.Text.Trim().Equals("") && (!StringUtility.isNumeric(AmountFedATextBox.Text) || !StringUtility.isNumeric(PriceFedATextBox.Text)))
        {
            inProperFormat = false;
            alertString += "alert('There needs to be proper corresponding values for Feed Type A');";
        }
        //If there are not numerical values for the feed type or price of feed type A 
        else if (!AmountFedATextBox.Text.Trim().Equals("") && (FeedTypeATextBox.Text.Equals("") || !StringUtility.isNumeric(PriceFedATextBox.Text) || !StringUtility.isNumeric(AmountFedATextBox.Text)))
        {
            inProperFormat = false;
            alertString += "alert('There needs to be proper corresponding values for the amount of Feed Type A');";
        }
        //If there are not numerical values for the feed type or amount of feed type A
        else if (!PriceFedATextBox.Text.Trim().Equals("") && (FeedTypeATextBox.Text.Equals("") || !StringUtility.isNumeric(PriceFedATextBox.Text) || !StringUtility.isNumeric(AmountFedATextBox.Text)))
        {
            inProperFormat = false;
            alertString += "alert('There needs to be proper corresponding values for the price of Feed Type A');";
        }
        //If there are not numerical values for the amount or price of feed type B
        if (!FeedTypeBTextBox.Text.Trim().Equals("") && (!StringUtility.isNumeric(AmountFedBTextBox.Text) || !StringUtility.isNumeric(PriceFedBTextBox.Text)))
        {
            inProperFormat = false;
            alertString += "alert('There needs to be proper corresponding values for Feed Type B');";
        }
        //If there are not numerical values for the feed type or price of feed type B
        else if (!AmountFedBTextBox.Text.Trim().Equals("") && (FeedTypeBTextBox.Text.Equals("") || !StringUtility.isNumeric(PriceFedBTextBox.Text) || !StringUtility.isNumeric(AmountFedBTextBox.Text)))
        {
            inProperFormat = false;
            alertString += "alert('There needs to be proper corresponding values for the amount of Feed Type B');";
        }
        //If there are not numerical values for the feed type or amount of feed type B
        else if (!PriceFedBTextBox.Text.Trim().Equals("") && (FeedTypeBTextBox.Text.Equals("") || !StringUtility.isNumeric(PriceFedBTextBox.Text) || !StringUtility.isNumeric(AmountFedBTextBox.Text)))
        {
            inProperFormat = false;
            alertString += "alert('There needs to be proper corresponding values for the price of Feed Type B');";
        }

        //If the price of type A field has something entered but is not numeric but is below zero   

        if (StringUtility.isNumeric(PriceFedATextBox.Text) && Decimal.Parse(PriceFedATextBox.Text) <= 0)
        {
            inProperFormat = false;
            alertString += "alert('The price for Feed Type A needs to be above zero');";
        }
        //If the price of type B field has something entered but is not numeric but is below zero 

        if (StringUtility.isNumeric(PriceFedBTextBox.Text) && Decimal.Parse(PriceFedBTextBox.Text) <= 0)
        {
            inProperFormat = false;
            alertString += "alert('The price for Feed Type B needs to be above zero');";
        }
        //If the amount of type A field has something entered but is not numeric but is below zero   
        if (StringUtility.isNumeric(AmountFedATextBox.Text) && Decimal.Parse(AmountFedATextBox.Text) <=0)
        {
            inProperFormat = false;
            alertString += "alert('The amount for Feed Type A needs to be above zero');";
        }
        //If the amount of type B field has something entered but is not numeric but is below zero  
        if (StringUtility.isNumeric(AmountFedBTextBox.Text) && Decimal.Parse(AmountFedBTextBox.Text) <=0)
        {
            inProperFormat = false;
            alertString += "alert('The amount for Feed Type B needs to be above zero');";
        }

        //If the number of days field is not an integer
        if (!StringUtility.isInteger(NumDaysBox.Text))
        {
            inProperFormat = false;
            alertString += "alert('Need to have an actual integer for the number of days');";
        }
        //If the number of days field has something entered in it but is below zero
        if (StringUtility.isNumeric(NumDaysBox.Text) && Decimal.Parse(NumDaysBox.Text) <=0)
        {
            inProperFormat = false;
            alertString += "alert('Number of days needs to be above zero');";
        }
        //If the number of days is more than that given in the specified month
        if (StringUtility.isNumeric(NumDaysBox.Text) && Decimal.Parse(NumDaysBox.Text) > CalendarUtility.numDaysInMonth(CalendarUtility.nextMonthString(lotTable[lotTable.Length-1].Month,1)))
        {
            inProperFormat = false;
            alertString += "alert('The specified number of days given is more than there is in the given month');";
        }
        //If it is the first month after the brooding period and number of days are more than that since the initial feeding date
        else if (lotTable.Length==3&&StringUtility.isNumeric(NumDaysBox.Text))
        {
            int initialNumDays = CalendarUtility.numDaysInMonth(new StationLotDataContext().ST_Stations_Lots.Find(LotList.Text).Initial_feeding_date);
            
             
            if (initialNumDays < Int32.Parse(NumDaysBox.Text))
            {
                inProperFormat = false;
                alertString += "alert('The specified number of days does not agree with the initial feeding date');";

            }
        }
        //Construct the alert string
        if (!inProperFormat)
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "alert", alertString, true);

        return inProperFormat;
    }

    //Clear all the text boxes
    private void clearTextBoxes()
    {
        NumEggsOnHandBox.Text = "";
        WeightBox.Text = "";
        MortalityRateBox.Text = "";
        InventoryAdjustmentBox.Text = "";
        EggsTransferredInNumBox.Text = "";
        EggsTransferredInWeightBox.Text = "";
        EggsTransferredOutNumBox.Text = "";
        EggsTransferredOutWeightBox.Text = "";
        FishStockedNumBox.Text = "";
        FishStockedWeightBox.Text = "";
        FeedTypeATextBox.Text = "";
        FeedTypeBTextBox.Text = "";
        AmountFedATextBox.Text = "";
        AmountFedBTextBox.Text = "";
        PriceFedATextBox.Text = "";
        PriceFedBTextBox.Text = "";
        CumLengthBox.Text = "";
        NumDaysBox.Text = "";
        CommentsTextBox.Text = "";
    }
    //Method to choose which controls to select
    private void enableSelectControls()
    {
        //If the lot table is null or there no rows for the selected lot
        if (lotTable==null||lotTable.Length == 0)
        {
            NumEggsOnHandBox.Enabled = false;
            WeightBox.Enabled = false;
            MortalityRateBox.Enabled = false;
            InventoryAdjustmentBox.Enabled = false;
            EggsTransferredInNumBox.Enabled = false;
            EggsTransferredInWeightBox.Enabled = false;
            EggsTransferredOutNumBox.Enabled = false;
            EggsTransferredOutWeightBox.Enabled = false;
            FishStockedNumBox.Enabled = false;
            FishStockedWeightBox.Enabled = false;
            FeedTypeATextBox.Enabled = false;
            FeedTypeBTextBox.Enabled = false;
            AmountFedATextBox.Enabled = false;
            AmountFedBTextBox.Enabled = false;
            PriceFedATextBox.Enabled = false;
            PriceFedBTextBox.Enabled = false;
            CumLengthBox.Enabled = false;
            NumDaysBox.Enabled = false;
            CommentsTextBox.Enabled = false;
            CumLengthLabel.Text = "Length at the end of last month (in)";
        }
        else
        {

            NumEggsOnHandBox.Enabled = true;
            WeightBox.Enabled = true;
            MortalityRateBox.Enabled = true;
            InventoryAdjustmentBox.Enabled = true;
            EggsTransferredInNumBox.Enabled = true;
            EggsTransferredInWeightBox.Enabled = true;
            EggsTransferredOutNumBox.Enabled = true;
            EggsTransferredOutWeightBox.Enabled = true;
            FishStockedNumBox.Enabled = true;
            FishStockedWeightBox.Enabled = true;

            FeedTypeATextBox.Enabled = true;
            FeedTypeBTextBox.Enabled = true;
            AmountFedATextBox.Enabled = true;
            AmountFedBTextBox.Enabled = true;
            PriceFedATextBox.Enabled = true;
            PriceFedBTextBox.Enabled = true;
            NumDaysBox.Enabled = true;
            CommentsTextBox.Enabled = true;
            //If the previous length has reached 9.5 inches, the length can be manually entered
            if ((Double)lotTable[lotTable.Length - 1].Length_on_last_day_of_month >= 9.5)
            {
                CumLengthBox.Enabled = true;
                CumLengthLabel.Text = "Length on last day of month (in)(*)";
            }
            else
            {
                CumLengthBox.Text = "";
                CumLengthLabel.Text = "Length on last day of month (in)";
                CumLengthBox.Enabled = false;
            }

        }
    }
    //Repopulate the lot and cycle lists when the station list is reselected 
    protected void StationList_SelectedIndexChanged(object sender, EventArgs e)
    {
        LotList.Items.Clear();
        populateLotList();
        populateLotTable();
        enableSelectControls();

    }

    //Insert the necessary rows
    private void insertNewRow()
    {
        setValues();
        lotContext.ST_Lot_History_Data.Add(lotData);
        lotContext.SaveChanges();
        populateLotTable();
        enableSelectControls();
        clearTextBoxes();
    }
    //Set the initial values based on user input
    private void setValues()
    {
        lotData = new ST_Lot_History_Data();
        lotData.Lot_Number = LotList.SelectedValue;
        lotData.Months_Recorded = lotTable.Length+1;
        String nextMonthStr = CalendarUtility.nextMonthString((string)lotTable[lotTable.Length - 1].Month,1);
        lotData.Month = nextMonthStr;
        lotData.Num_eggs_on_hand = Int32.Parse(NumEggsOnHandBox.Text.Trim().Equals("")?lotTable[lotTable.Length-1].Num_eggs_on_hand.ToString():NumEggsOnHandBox.Text);
        lotData.Eggs_on_hand_weight= WeightBox.Text.Trim().Equals("") ? 0 : Decimal.Parse(WeightBox.Text);
        lotData.Num_Mortalities = (MortalityRateBox.Text.Trim().Equals("") ? 0 : Int32.Parse(MortalityRateBox.Text));
        lotData.Inv_adj_num = (InventoryAdjustmentBox.Text.Trim().Equals("") ? 0 : Int32.Parse(InventoryAdjustmentBox.Text));
        lotData.Eggs_spawned_num = 0;
        lotData.Eggs_pick_off_num = 0;
        lotData.Num_eggs_trans_in = (EggsTransferredInNumBox.Text.Trim().Equals("") ? 0 : Int32.Parse(EggsTransferredInNumBox.Text));
        lotData.Eggs_trans_in_weight = (EggsTransferredInWeightBox.Text.Trim().Equals("") ? 0 : Decimal.Parse(EggsTransferredInWeightBox.Text));
        lotData.Num_eggs_trans_out = (EggsTransferredOutNumBox.Text.Trim().Equals("") ? 0 : Int32.Parse(EggsTransferredOutNumBox.Text));
        lotData.Eggs_trans_in_weight = (EggsTransferredOutWeightBox.Text.Trim().Equals("") ? 0 : Decimal.Parse(EggsTransferredOutWeightBox.Text));
        lotData.Fish_stocked_num = (FishStockedNumBox.Text.Trim().Equals("") ? 0 : Int32.Parse(FishStockedNumBox.Text));
        lotData.Fish_stocked_weight = (FishStockedWeightBox.Text.Trim().Equals("") ? 0 : Int32.Parse(FishStockedWeightBox.Text));
        lotData.Feed_Type_A = (FeedTypeATextBox.Text.Trim().Equals("") ? "" : FeedTypeATextBox.Text);
        lotData.Feed_Type_B = (FeedTypeBTextBox.Text.Trim().Equals("") ? "" : FeedTypeBTextBox.Text);
        lotData.Amount_Fed_A = (AmountFedATextBox.Text.Trim().Equals("") ? 0 : Decimal.Parse(AmountFedATextBox.Text));
        lotData.Amount_Fed_B = (AmountFedBTextBox.Text.Trim().Equals("") ? 0 : Decimal.Parse(AmountFedBTextBox.Text));
        lotData.Unit_Price_Fed_A = (PriceFedATextBox.Text.Trim().Equals("")? 0 : Decimal.Parse(PriceFedATextBox.Text));
        lotData.Unit_Price_Fed_B = (PriceFedBTextBox.Text.Trim().Equals("") ? 0 : Decimal.Parse(PriceFedBTextBox.Text));
        lotData.Length_on_last_day_of_month =Decimal.Round(Decimal.Parse(CumLengthBox.Text.Trim().Equals("") ? lotTable[lotTable.Length - 1].Length_on_last_day_of_month.ToString() : CumLengthBox.Text),2);
        lotData.Num_of_days_feed_per_month = Int32.Parse(NumDaysBox.Text.Trim().Equals("") ? CalendarUtility.numDaysInMonth(nextMonthStr).ToString() : NumDaysBox.Text);
        lotData.Comments = CommentsTextBox.Text;

    }

    //When the insert button is clicked
    protected void InsertLotHistoryButton_Click(object sender, EventArgs e)
    {
        //Re populate the lot table and do validation
        populateLotTable();
        if (!checkAllFields())
            return;
        //Insert a new row
        insertNewRow();
    }

    //When the lot list is selected, change controls accordingly
    protected void LotList_SelectedIndexChanged(object sender, EventArgs e)
    {
        populateLotTable();
        enableSelectControls();

    }
</script>

<div style="background-color:aqua;">
    
    <div style="margin-left: 0px; text-align: center;">   
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
&nbsp;&nbsp;&nbsp; Lot Number<asp:DropDownList ID="LotList" runat="server" OnSelectedIndexChanged="LotList_SelectedIndexChanged" AutoPostBack="True">
        </asp:DropDownList>
        &nbsp;
        <br />
        Number of eggs on hand
        (*)
        <asp:TextBox ID="NumEggsOnHandBox" style="margin-right:100px" runat="server"></asp:TextBox>
        <br />
        
        <asp:Label ID="Label1" runat="server" Text="Weight of eggs on hand" style="margin-left:-95px"></asp:Label>
        
&nbsp;(lb)&nbsp;(*)<asp:TextBox ID="WeightBox" runat="server"></asp:TextBox>
    
        <br />
        Mortality Rate
        <asp:TextBox ID="MortalityRateBox" style="margin-right:40px" runat="server"></asp:TextBox>

    
        <br />
        <asp:Label ID="Label5" runat="server" style="margin-left:-135px" Text="Inventory Adjustment Number"></asp:Label>
        <asp:TextBox ID="InventoryAdjustmentBox" runat="server"></asp:TextBox>
    
        <br />
        <asp:Label ID="Label8" runat="server" Text="Eggs Transferred In Number"></asp:Label>
        <asp:TextBox ID="EggsTransferredInNumBox" runat="server"></asp:TextBox>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="Label9" runat="server" Text=" Weight"></asp:Label>
        &nbsp;<asp:TextBox ID="EggsTransferredInWeightBox" runat="server"></asp:TextBox>
    
        <br />
    
        <asp:Label ID="Label6" runat="server" Text="Eggs Transferred Out Number"></asp:Label>
        <asp:TextBox ID="EggsTransferredOutNumBox" runat="server"></asp:TextBox>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="Label7" runat="server" Text=" Weight"></asp:Label>
        &nbsp;<asp:TextBox ID="EggsTransferredOutWeightBox" runat="server"></asp:TextBox>
    
        <br />
        <asp:Label ID="Label3" runat="server" Text="Fish Stocked Number"></asp:Label>
        <asp:TextBox ID="FishStockedNumBox" runat="server"></asp:TextBox>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="Label2" runat="server" Text=" Weight"></asp:Label>
        &nbsp;<asp:TextBox ID="FishStockedWeightBox" runat="server"></asp:TextBox>
    
        <br />
        Feed Type A
        (*)
        <asp:TextBox ID="FeedTypeATextBox" runat="server"></asp:TextBox>
&nbsp;Amount
        (lb)
        (*)
        <asp:TextBox ID="AmountFedATextBox" runat="server"></asp:TextBox>
&nbsp;Unit Price ($)(*)
        <asp:TextBox ID="PriceFedATextBox" runat="server"></asp:TextBox>
        <br />
        Feed Type B<asp:TextBox ID="FeedTypeBTextBox" runat="server"></asp:TextBox>
&nbsp;Amount
        (lb)
        <asp:TextBox ID="AmountFedBTextBox" runat="server"></asp:TextBox>
&nbsp;Unit Price ($)
        <asp:TextBox ID="PriceFedBTextBox" runat="server"></asp:TextBox>
    
        <br />
        <asp:Label ID="CumLengthLabel" runat="server" Text="Length on last day of month (in)"></asp:Label>
&nbsp;<asp:TextBox ID="CumLengthBox" style="margin-right:135px;" runat="server"></asp:TextBox>

    
        <br />
        Number of days feeding (*)&nbsp;&nbsp;
        <asp:TextBox ID="NumDaysBox" style="margin-right:105px" runat="server"></asp:TextBox>
        <br />
        <br />

    
        <div> &nbsp; <asp:Label ID="Label4" runat="server" Text="Comments" style=" margin-bottom:50px;vertical-align:central"></asp:Label>
&nbsp;
        <asp:TextBox ID="CommentsTextBox" runat="server" TextMode="MultiLine" style ="margin-bottom:-30px" Height="64px" Width="269px"></asp:TextBox>
        </div><br />
       
        <asp:Button ID="InsertLotHistoryButton" runat="server" style="margin-top:20px" Text="Insert Lot History" OnClick="InsertLotHistoryButton_Click" />

    
        <br />
        &nbsp;
        <asp:HyperLink ID="MainPageHyperLink" NavigateUrl="~/MainPage.aspx"  runat="server" Font-Underline="True" ForeColor="#0033CC">Back To Main Page</asp:HyperLink>

    
    </div>
    
</div>
</asp:Content>
