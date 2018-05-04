<%@ Page Language="C#" MasterPageFile="~/Site.master" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <%@ import Namespace="ModelClasses" %>
    <%@ import Namespace="System.Globalization" %>
    <script runat="server">

        private ST_Lot_History_Data[] lotTable;
        ST_Lot_History_Data lotDataRecord;
        LotHistoryDataContext lotContext;
        StationLotDataContext stationContext;
        protected void Page_Load(object sender, EventArgs e)
        {
            //When the page first loads
            if (!Page.IsPostBack) {
         //Initialize data objects            
        lotDataRecord = new ST_Lot_History_Data();
        lotContext = new LotHistoryDataContext();
        stationContext = new StationLotDataContext();
        
                //If user is not valid, redirect the user, otherwise populate the lists
                if (!HttpContext.Current.User.Identity.IsAuthenticated)
                    Response.Redirect("MainPage.aspx");
                populateLotList();
                populateMonthList();
                populateLotTable();
                enableSelectControls();
            }


        }


        //Populate the lot list
        private void populateLotList()
        {
            var lotCycles = stationContext.ST_Stations_Lots.Where(data => data.Station == StationList.Text).ToArray();
            //Load all the lot numbers
            foreach (var lotCycle in lotCycles)
                LotList.Items.Add(lotCycle.Lot_Number);
        }
        //Method to determine whether number of eggs quantity is in proper order
        private bool eggsInProperOrder(Decimal quantity)
        {
            if (MonthList.Items.Count==1)
                return true;
            if (MonthList.SelectedIndex == 0)
            {

                return quantity >= lotTable[1].Num_eggs_on_hand;
            }
            else if (MonthList.SelectedIndex == MonthList.Items.Count - 1)
            {

                return quantity <= lotTable[lotTable.Length - 2].Num_eggs_on_hand;
            }
            else
            {
                return quantity <= lotTable[MonthList.SelectedIndex - 1].Num_eggs_on_hand && quantity >= lotTable[MonthList.SelectedIndex + 1].Num_eggs_on_hand;

            }
        }
        //Method to determine length is in proper order
        private bool lengthInProperOrder(Decimal quantity)
        {
            if (MonthList.Items.Count==1)
                return true;
            if (MonthList.SelectedIndex == 0)
            {

                return quantity <= lotTable[1].Length_on_last_day_of_month;

            }
            else if (MonthList.SelectedIndex == MonthList.Items.Count - 1)
            {
                return quantity >= lotTable[lotTable.Length - 2].Length_on_last_day_of_month;
            }
            else
            {
                return quantity >= lotTable[MonthList.SelectedIndex - 1].Length_on_last_day_of_month && quantity <= lotTable[MonthList.SelectedIndex + 1].Length_on_last_day_of_month;
            }
        }
        //Main validation method
        private bool checkAllFields()
        {
            bool inProperFormat = true;
            String alertString = "";
            //If there is no valid lot cycle, reject immediately
            if (LotList.Text.Trim().Equals("")||MonthList.Text.Trim().Equals(""))
            {
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "alert", "alert('There is no valid lot cycle or month with which to update');", true);
                return false;
            }

            //If the number of eggs on hand field has something entered but is not an integer  
            if (!StringUtility.isInteger(NumEggsTextBox.Text)&&!NumEggsTextBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual integer for the number of eggs on hand');";
            }
            //If the number of eggs on hand field has something entered but is below zero   
            if (StringUtility.isNumeric(NumEggsTextBox.Text) && Decimal.Parse(NumEggsTextBox.Text) <= 0)
            {
                inProperFormat = false;
                alertString += "alert('Number of eggs on hand needs to be above zero');";
            }
            //If the number of eggs on hand is more than the previous value
            if (StringUtility.isNumeric(NumEggsTextBox.Text) && !eggsInProperOrder(Decimal.Parse(NumEggsTextBox.Text)))
            {
                inProperFormat = false;
                alertString += "alert('Number of eggs on hand needs to be in proper order');";
            }

            //If the weight of eggs on hand field has something entered but is not numeric   
            if (!StringUtility.isNumeric(WeightTextBox.Text)&&!WeightTextBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual number for the weight of the eggs on hand');";
            }
            //If the weight of eggs on hand field has something entered but is below zero   
            if (StringUtility.isNumeric(WeightTextBox.Text) && Decimal.Parse(WeightTextBox.Text) <= 0)
            {
                inProperFormat = false;
                alertString += "alert('Weight of eggs on hand needs to be above zero');";
            }
            //If the mortality rate field has something entered but is not an integer   
            if (!StringUtility.isInteger(MortalityRateTextBox.Text) && !MortalityRateTextBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual integer for the mortality rate');";
            }
            //If the number of eggs on hand field has something entered but is below zero
            if (StringUtility.isNumeric(MortalityRateTextBox.Text) && Decimal.Parse(MortalityRateTextBox.Text) < 0)
            {
                inProperFormat = false;
                alertString += "alert('Mortality rate needs to be positive');";
            }
            //If the inventory adjustment box field has something entered but is not an integer
            if (!StringUtility.isInteger(InventoryAdjustmentNumberBox.Text) && !InventoryAdjustmentNumberBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual integer for the inventory adjustment number');";
            }
            //If the number of eggs spawned field has something entered but is not an integer   
            if (!StringUtility.isInteger(EggsSpawnedNumberBox.Text) && !EggsSpawnedNumberBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual integer for the number of eggs spawned');";
            }
            //If the number of eggs spawned field has something entered but is below zero   
            if (StringUtility.isNumeric(EggsSpawnedNumberBox.Text) && Decimal.Parse(EggsSpawnedNumberBox.Text) <= 0)
            {
                inProperFormat = false;
                alertString += "alert('Number of eggs spawned needs to be above zero');";
            }
            //If the number of eggs picked off field has something entered but is not an integer   
            if (!StringUtility.isInteger(EggsPickOffNumBox.Text) && !EggsPickOffNumBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual integer for the number of eggs picked off');";
            }
            //If the number of eggs picked off field has something entered but is below zero  

            if (StringUtility.isNumeric(EggsPickOffNumBox.Text) && Decimal.Parse(EggsPickOffNumBox.Text) <= 0)
            {
                inProperFormat = false;
                alertString += "alert('Number of eggs picked off needs to be above zero');";
            }
            //If the number of eggs transferred in field has something entered but is not an integer 
            if (!StringUtility.isInteger(EggsTransferredInNumBox.Text) && !EggsTransferredInNumBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual integer for the number of fish transferred in');";
            }
            //If the number of eggs transferred in field has something entered but is below zero   
            if (StringUtility.isNumeric(EggsTransferredInNumBox.Text) && Decimal.Parse(EggsTransferredInNumBox.Text) <= 0)
            {
                inProperFormat = false;
                alertString += "alert('Number of fish transferred in needs to be above zero');";
            }
            //If the weight of eggs transferred in field has something entered but is not numeric   
            if (!StringUtility.isNumeric(EggsTransferredInWeightBox.Text) && !EggsTransferredInWeightBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual number for the weight of fish transferred in');";
            }
            //If the weight of eggs transferred in field has something entered but is below zero   

            if (StringUtility.isNumeric(EggsTransferredInWeightBox.Text) && Decimal.Parse(EggsTransferredInWeightBox.Text) <= 0)
            {
                inProperFormat = false;
                alertString += "alert('Weight of fish on transferred in needs to be above zero');";
            }
            //If the eggs transferred in number does not have a corresponding weight or vice versa
            if (EggsTransferredInNumBox.Text.Trim().Equals("") && !EggsTransferredInWeightBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('There needs to be a number entered for the number of eggs transferred in')";

            }
            else if (EggsTransferredInWeightBox.Text.Trim().Equals("") && !EggsTransferredInNumBox.Text.Trim().Equals(""))
            {

                inProperFormat = false;
                alertString += "alert('There needs to be a weight entered for the number of eggs transferred in')";

            }
            //If the number of eggs transferred out field has something entered but is not numeric  
            if (!StringUtility.isInteger(EggsTransferredOutNumBox.Text) && !EggsTransferredOutNumBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual integer of fish transferred out');";
            }
            //If the number of eggs transferred out field has something entered but is below zero   
            if (StringUtility.isNumeric(EggsTransferredOutNumBox.Text) && Decimal.Parse(EggsTransferredOutNumBox.Text) <= 0)
            {
                inProperFormat = false;
                alertString += "alert('Number of fish transferred out needs to be above zero');";
            }
            //If the weight of eggs transferred out field has something entered but is not numeric   

            if (!StringUtility.isNumeric(EggsTransferredOutWeightBox.Text) && !EggsTransferredOutWeightBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual number for the weight of fish transferred out');";
            }
            //If the weight of eggs transferred out field has something entered but is not numeric   

            if (StringUtility.isNumeric(EggsTransferredOutWeightBox.Text) && Decimal.Parse(EggsTransferredOutWeightBox.Text) <= 0)
            {
                inProperFormat = false;
                alertString += "alert('Weight of fish transferred out needs to be above zero');";
            }
            //If the eggs transferred out number does not have a corresponding weight or vice versa
            if (EggsTransferredOutNumBox.Text.Trim().Equals("") && !EggsTransferredOutWeightBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('There needs to be a number entered for the number of eggs transferred in')";

            }
            else if (EggsTransferredOutWeightBox.Text.Trim().Equals("") && !EggsTransferredOutNumBox.Text.Trim().Equals(""))
            {

                inProperFormat = false;
                alertString += "alert('There needs to be a weight entered for the number of eggs transferred in')";

            }

            //If the number of fish stocked field has something entered but is not an integer  

            if (!StringUtility.isInteger(FishStockedNumBox.Text) && !FishStockedNumBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual integer for the number of fish stocked');";
            }
            //If the number of fish stocked field has something entered but is below zero 

            if (StringUtility.isNumeric(FishStockedNumBox.Text) && Decimal.Parse(FishStockedNumBox.Text) <= 0)
            {
                inProperFormat = false;
                alertString += "alert('Number of fish stocked needs to be above zero');";
            }
            //If the weight of fish stocked field has something entered but is not numeric   

            if (!StringUtility.isNumeric(FishStockedWeightBox.Text) && !FishStockedWeightBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual number for the weight of fish stocked');";
            }
            //If the weight of fish stocked field has something entered but is not numeric   

            if (StringUtility.isNumeric(FishStockedWeightBox.Text) && Decimal.Parse(FishStockedWeightBox.Text) <= 0)
            {
                inProperFormat = false;
                alertString += "alert('Weight of fish stocked out needs to be above zero');";
            }
            //If the fish number does not have a corresponding weight or vice versa
            if (FishStockedNumBox.Text.Trim().Equals("") && !FishStockedWeightBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('There needs to be a number entered for the number of eggs transferred in')";

            }
            else if (FishStockedWeightBox.Text.Trim().Equals("") && !FishStockedNumBox.Text.Trim().Equals(""))
            {

                inProperFormat = false;
                alertString += "alert('There needs to be a weight entered for the number of eggs transferred in')";

            }

            //If the price of type A field has something entered but is not numeric   

            if (!StringUtility.isNumeric(PriceFedATextBox.Text) && !PriceFedATextBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('The price for Feed Type A needs to be a number');";
            }
            //If the price of type B field has something entered but is not numeric   

            if (!StringUtility.isNumeric(PriceFedBTextBox.Text) && !PriceFedBTextBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('The price for Feed Type B needs to be a number');";
            }
            //If the amount of type A field has something entered but is not numeric   
            if (!StringUtility.isNumeric(AmountFedATextBox.Text) && !AmountFedATextBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('The amount for Feed Type A needs to be a number');";
            }
            //If the amount of type B field has something entered but is not numeric   
            if (!StringUtility.isNumeric(AmountFedBTextBox.Text) && !AmountFedBTextBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('The amount for Feed Type B needs to be a number');";
            }
            //If the price of type A field has something entered but is not numeric but is below zero  

            if (StringUtility.isNumeric(PriceFedATextBox.Text) && Decimal.Parse(PriceFedATextBox.Text)<=0)
            {
                inProperFormat = false;
                alertString += "alert('The price for Feed Type A needs to be above zero');";
            }
            //If the price of type B field has something entered but is not numeric but is below zero  

            if (StringUtility.isNumeric(PriceFedBTextBox.Text) && Decimal.Parse(PriceFedBTextBox.Text)<=0)
            {
                inProperFormat = false;
                alertString += "alert('The price for Feed Type B needs to be above zero');";
            }
            //If the amount of type A field has something entered but is not numeric but is below zero  
            if (StringUtility.isNumeric(AmountFedATextBox.Text) && Decimal.Parse(AmountFedATextBox.Text)<=0)
            {
                inProperFormat = false;
                alertString += "alert('The amount for Feed Type A needs to be above zero');";
            }
            //If the amount of type B field has something entered but is not numeric but is below zero  
            if (StringUtility.isNumeric(AmountFedBTextBox.Text) && Decimal.Parse(AmountFedBTextBox.Text)<=0)
            {
                inProperFormat = false;
                alertString += "alert('The amount for Feed Type B needs to be above zero');";
            }

            //If the name of Feed Type B is being updated but there are not proper corresponding values for the other fields
            if (!FeedTypeBTextBox.Text.Trim().Equals(""))
            {

                if ((Double)lotTable[MonthList.SelectedIndex].Amount_Fed_B<=0.0 &&(!StringUtility.isNumeric(AmountFedBTextBox.Text)||Double.Parse(AmountFedBTextBox.Text)<=0.0)) {
                    inProperFormat = false;
                    alertString += "alert('There needs to be a proper amount for Feed Type B');";
                }
                if ((Double)lotTable[MonthList.SelectedIndex].Unit_Price_Fed_B <= 0.0 && (!StringUtility.isNumeric(PriceFedBTextBox.Text) || Double.Parse(PriceFedBTextBox.Text) <= 0.0))
                {
                    inProperFormat = false;
                    alertString += "alert('There needs to be a proper amount for Feed Type B');";
                }
            }
            else if (!PriceFedBTextBox.Text.Trim().Equals(""))
            {

                if (FeedTypeBTextBox.Text.Trim().Equals("")&&lotTable[MonthList.SelectedIndex].Feed_Type_B.ToString().Trim().Equals(""))
                {
                    inProperFormat = false;
                    alertString += "alert('There needs to be a proper name for Feed Type B');";

                }
                if ((Double.Parse(lotTable[MonthList.SelectedIndex].Amount_Fed_B.ToString()) <= 0.0 && (!StringUtility.isNumeric(AmountFedBTextBox.Text) || Double.Parse(AmountFedBTextBox.Text) <= 0.0)))
                {
                    inProperFormat = false;
                    alertString += "alert('There needs to be a proper amount for Feed Type B');";
                }


            }
            else if (!AmountFedBTextBox.Text.Trim().Equals(""))
            {
                if (FeedTypeBTextBox.Text.Trim().Equals("") && lotTable[MonthList.SelectedIndex].Feed_Type_B.Trim().Equals(""))
                {
                    inProperFormat = false;
                    alertString += "alert('There needs to be a proper name for Feed Type B');";

                }
                if ((Double)lotTable[MonthList.SelectedIndex].Unit_Price_Fed_B <= 0.0 && (!StringUtility.isNumeric(PriceFedBTextBox.Text) || Double.Parse(PriceFedBTextBox.Text) <= 0.0))
                {
                    inProperFormat = false;
                    alertString += "alert('There needs to be a proper amount for Feed Type B');";
                }

            }


            //If the cumulative length field has something entered but is not numeric   
            if (!StringUtility.isNumeric(CumLengthBox.Text)&&!CumLengthBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual number for the cumulative box');";
            }
            //If the cumulative length field has something entered but is below zero   
            if (StringUtility.isNumeric(CumLengthBox.Text) && Decimal.Parse(CumLengthBox.Text) <= 0)
            {
                inProperFormat = false;
                alertString += "alert('The cumulative length needs to be above zero');";
            }
            //If the cumulative length is more than the previous value
            if (StringUtility.isNumeric(CumLengthBox.Text) && !lengthInProperOrder(Decimal.Parse(CumLengthBox.Text)))
            {
                inProperFormat = false;
                alertString += "alert('Cumulative length needs to be in proper order');";
            }
            //If the number of days field has something entered but is not an integer   
            if (!StringUtility.isInteger(NumDaysBox.Text)&&!NumDaysBox.Text.Trim().Equals(""))
            {
                inProperFormat = false;
                alertString += "alert('Need to have an actual integer for the number of days');";
            }
            //If the number of days field has something entered but is below zero   
            if (StringUtility.isNumeric(NumDaysBox.Text) && Decimal.Parse(NumDaysBox.Text) <= 0)
            {
                inProperFormat = false;
                alertString += "alert('Number of days needs to be above zero');";
            }
            //If the number of days is more than that given in the specified month
            if (StringUtility.isNumeric(NumDaysBox.Text) && Decimal.Parse(NumDaysBox.Text)>CalendarUtility.numDaysInMonth(MonthList.Text))
            {
                inProperFormat = false;
                alertString += "alert('The specified number of days given is more than there is in the given month');";
            }
            //If it is the first month after the brooding period and number of days are more than that since the initial feeding date
            else if (MonthList.SelectedIndex==3 && StringUtility.isNumeric(NumDaysBox.Text))
            {
                int initialNumDays = CalendarUtility.numDaysInMonth(stationContext.ST_Stations_Lots.Find(LotList.Text).Initial_feeding_date);
               if (initialNumDays < Decimal.Parse(NumDaysBox.Text))
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


        //Method to populate the lot table
        private void populateLotTable()
        {

            lotTable = lotContext.ST_Lot_History_Data.Where(record=>record.Lot_Number==LotList.Text).ToArray();
            lotDataRecord = lotContext.ST_Lot_History_Data.Find(LotList.Text, MonthList.SelectedIndex + 1, MonthList.Text);
        }

        //Enable certain controls
        private void enableSelectControls()
        {
            if (lotTable == null || lotTable.Length == 0)
            {
                NumEggsTextBox.Enabled = false;
                WeightTextBox.Enabled = false;
                MortalityRateTextBox.Enabled = false;
                InventoryAdjustmentNumberBox.Enabled = false;
                EggsSpawnedNumberBox.Enabled = false;
                EggsPickOffNumBox.Enabled = false;
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
            }
            else
            {

                NumEggsTextBox.Enabled = true;
                InventoryAdjustmentNumberBox.Enabled = true;
                CommentsTextBox.Enabled = true;


                if (MonthList.SelectedIndex>0&&(double)lotTable[MonthList.SelectedIndex-1].Length_on_last_day_of_month >= 9.5)
                    CumLengthBox.Enabled = true;
                else
                {
                    CumLengthBox.Text = "";
                    CumLengthBox.Enabled = false;
                }

                if (MonthList.SelectedIndex > 2)
                {
                    EggsTransferredInNumBox.Enabled = true;
                    EggsTransferredInWeightBox.Enabled = true;
                    EggsTransferredOutNumBox.Enabled = true;
                    EggsTransferredOutWeightBox.Enabled = true;
                    FishStockedNumBox.Enabled = true;
                    FishStockedWeightBox.Enabled = true;
                    WeightTextBox.Enabled = true;
                    MortalityRateTextBox.Enabled = true;
                    NumDaysBox.Enabled = true;
                    FeedTypeATextBox.Enabled = true;
                    FeedTypeBTextBox.Enabled = true;
                    AmountFedATextBox.Enabled = true;
                    AmountFedBTextBox.Enabled = true;
                    PriceFedATextBox.Enabled = true;
                    PriceFedBTextBox.Enabled = true;
                    EggsSpawnedNumberBox.Enabled = false;
                    EggsPickOffNumBox.Enabled = false;
                }
                else
                {
                    EggsTransferredInNumBox.Enabled = false;
                    EggsTransferredInWeightBox.Enabled = false;
                    EggsTransferredOutNumBox.Enabled = false;
                    EggsTransferredOutWeightBox.Enabled = false;
                    FishStockedNumBox.Enabled = false;
                    FishStockedWeightBox.Enabled = false;
                    WeightTextBox.Enabled = false;
                    MortalityRateTextBox.Enabled = false;
                    NumDaysBox.Enabled = false;
                    FeedTypeATextBox.Enabled = false;
                    FeedTypeBTextBox.Enabled = false;
                    AmountFedATextBox.Enabled = false;
                    AmountFedBTextBox.Enabled = false;
                    PriceFedATextBox.Enabled = false;
                    PriceFedBTextBox.Enabled = false;
                    EggsSpawnedNumberBox.Enabled = true;
                    EggsPickOffNumBox.Enabled = true;
                }
                if (MonthList.SelectedIndex == 0)
                    EggsSpawnedNumberBox.Enabled = false;
            }
        }

        //Populates the month list
        private void populateMonthList()
        {
            //If there are no more lots in the list, do nothing
            if (LotList.Text.Trim().Equals(""))
                return;

            var lots = lotContext.ST_Lot_History_Data.Where(record=>record.Lot_Number==LotList.Text).ToArray();

            //Add more months
            for (int i = 0; i < lots.Length; i++)
            {
                MonthList.Items.Add(lots[i].Month);
            }
        }

        //Update the number of eggs on hand
        private void updateNumEggsOnHand()
        {
            int numEggsOnHand = (int)Double.Parse(NumEggsTextBox.Text);
            lotDataRecord.Num_eggs_on_hand = numEggsOnHand;
            //con.executeUpdateLotHistory("Num_eggs_on_hand",numEggsOnHand,MonthList.SelectedIndex+1,LotList.Text);
            if (MonthList.SelectedIndex == 0)
                lotDataRecord.Eggs_spawned_num = numEggsOnHand;
            // con.executeUpdateLotHistory("Eggs_spawned_num",numEggsOnHand,MonthList.SelectedIndex+1,LotList.Text);
            lotContext.SaveChanges();
        }

        //Update the weight
        private void updateWeight()
        {
            Decimal newWeight = Decimal.Parse(WeightTextBox.Text);
            lotDataRecord.Weight_Gain_per_month = newWeight;
            lotContext.SaveChanges();
        }

        //Update the cumulative cost of food
        private void updateFeedTypeACost()
        {
            Decimal feedCost = Decimal.Parse(PriceFedATextBox.Text);
            lotDataRecord.Unit_Price_Fed_A = feedCost;
            lotContext.SaveChanges();
        }

        //Update the cumulative cost of food
        private void updateFeedTypeBCost()
        {
            Decimal feedCost = Decimal.Parse(PriceFedBTextBox.Text);
            lotDataRecord.Unit_Price_Fed_B = feedCost;
            lotContext.SaveChanges();
        }
        //Update the feed type
        private void updateFeedTypeA()
        {
            lotDataRecord.Feed_Type_A = FeedTypeATextBox.Text;
            lotContext.SaveChanges();
        }
        //Update the feed type
        private void updateFeedTypeB()
        {
            lotDataRecord.Feed_Type_B = FeedTypeBTextBox.Text;
            lotContext.SaveChanges();
        }
        //Update the feed type
        private void updateFeedTypeAAmount()
        {
            lotDataRecord.Amount_Fed_A = Decimal.Parse(AmountFedATextBox.Text);
            lotContext.SaveChanges();
        }
        //Update the feed type
        private void updateFeedTypeBAmount()
        {
            lotDataRecord.Amount_Fed_B = Decimal.Parse(AmountFedBTextBox.Text);
            lotContext.SaveChanges();
        }
        //Update the length
        private void updateLength()
        {
            Decimal length = Decimal.Parse(CumLengthBox.Text);
            lotDataRecord.Length_on_last_day_of_month = length;
            lotContext.SaveChanges();
        }
        //Update the mortality rate
        private void updateMortalityRate()
        {
            Decimal mortalityRate = Decimal.Parse(MortalityRateTextBox.Text);
            lotDataRecord.Length_on_last_day_of_month = mortalityRate;
            lotContext.SaveChanges();
        }
        //Update the inventory adjustment number
        private void updateInventoryAdjustmentNumber()
        {
            Int32 invAdjNum = Int32.Parse(InventoryAdjustmentNumberBox.Text);
            lotDataRecord.Inv_adj_num = invAdjNum;
            lotContext.SaveChanges();
        }
        //Update the number of eggs spawned
        private void updateEggsSpawned()
        {
            Int32 spawnedNum = Int32.Parse(EggsSpawnedNumberBox.Text);
            lotDataRecord.Eggs_spawned_num = spawnedNum;
            lotContext.SaveChanges();
        }
        //Update the number of eggs picked off
        private void updateEggsPickOff()
        {
            Int32 pickedNum = Int32.Parse(EggsPickOffNumBox.Text);
            lotDataRecord.Eggs_pick_off_num = pickedNum;
            lotContext.SaveChanges();
        }
        //Update the number of eggs being transferred in
        private void updateEggsInNum()
        {
            Int32 newAmount = Int32.Parse(EggsTransferredInNumBox.Text);
            lotDataRecord.Num_eggs_trans_in = newAmount;
            lotContext.SaveChanges();
        }
        //Update the weight of eggs being transferred in
        private void updateEggsInWeight()
        {
            Decimal newWeight = Decimal.Parse(EggsTransferredInWeightBox.Text);
            lotDataRecord.Eggs_trans_in_weight = newWeight;
            lotContext.SaveChanges();
        }
        //Update the number of eggs being transferred out
        private void updateEggsOutNum()
        {
            Int32 newAmount = Int32.Parse(EggsTransferredOutNumBox.Text);
            lotDataRecord.Num_eggs_trans_out = newAmount;
            lotContext.SaveChanges();
        }
        //Update the weight of eggs being transferred out
        private void updateEggsOutWeight()
        {
            Decimal newWeight = Decimal.Parse(EggsTransferredOutWeightBox.Text);
            lotDataRecord.Eggs_trans_out_weight = newWeight;
            lotContext.SaveChanges();
        }
        //Update the number of fish stocked
        private void updateFishStockedNum()
        {
            Int32 stockedNum = Int32.Parse(FishStockedNumBox.Text);
            lotDataRecord.Fish_stocked_num = stockedNum;
            lotContext.SaveChanges();
        }
        //Update the weight of fish stocked
        private void updateFishStockedWeight()
        {
            Int32 stockedWeight = Int32.Parse(FishStockedWeightBox.Text);
            lotDataRecord.Fish_stocked_weight = stockedWeight;
            lotContext.SaveChanges();
        }


        //Update the weight of fish stocked
        private void updateNumDaysFeeding()
        {
            Int32 numDays = Int32.Parse(NumDaysBox.Text);
            lotDataRecord.Num_of_days_feed_per_month = numDays;
            lotContext.SaveChanges();
        }
        //Update the number of fish stocked
        private void updateComments()
        {
            lotDataRecord.Comments = CommentsTextBox.Text;
            lotContext.SaveChanges();
        }


        //Clear the text boxes
        private void clearTextBoxes()
        {
            NumEggsTextBox.Text = "";
            WeightTextBox.Text = "";
            MortalityRateTextBox.Text = "";
            InventoryAdjustmentNumberBox.Text = "";
            EggsSpawnedNumberBox.Text = "";
            EggsPickOffNumBox.Text = "";
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
        //When the update button is clicked
        protected void UpdateButton_Click(object sender, EventArgs e)
        {
            populateLotTable();
            //If data is not in the right format don't continue
            if (!checkAllFields())
                return;
            setValues();
        }
        //Set values based on user input
        private void setValues()
        {
            if (NumEggsTextBox.Text.Trim() != "")
                updateNumEggsOnHand();
            if (WeightTextBox.Text.Trim() != "")
                lotDataRecord.Weight_Gain_per_month = Decimal.Parse(WeightTextBox.Text);
            if (MortalityRateTextBox.Text.Trim() != "")
                lotDataRecord.Num_Mortalities = Int32.Parse(MortalityRateTextBox.Text);
            if (InventoryAdjustmentNumberBox.Text.Trim() != "")
                lotDataRecord.Inv_adj_num = Int32.Parse(InventoryAdjustmentNumberBox.Text);
            if (EggsSpawnedNumberBox.Text.Trim() != "")
                lotDataRecord.Eggs_spawned_num = Int32.Parse(EggsSpawnedNumberBox.Text);
            if (EggsPickOffNumBox.Text.Trim() != "")
                lotDataRecord.Eggs_pick_off_num = Int32.Parse(EggsPickOffNumBox.Text);
            if (EggsTransferredInNumBox.Text.Trim() != "")
                lotDataRecord.Num_eggs_trans_in = Int32.Parse(EggsTransferredInNumBox.Text);
            if (EggsTransferredInWeightBox.Text.Trim() != "")
                lotDataRecord.Eggs_trans_in_weight = Decimal.Parse(EggsTransferredInWeightBox.Text);
            if (EggsTransferredOutNumBox.Text.Trim() != "")
                lotDataRecord.Num_eggs_trans_out = Decimal.Parse(EggsTransferredOutNumBox.Text);
            if (EggsTransferredOutWeightBox.Text.Trim() != "")
                lotDataRecord.Eggs_trans_out_weight = Decimal.Parse(EggsTransferredOutWeightBox.Text);
            if (FishStockedNumBox.Text.Trim() != "")
                lotDataRecord.Fish_stocked_num = Int32.Parse(FishStockedNumBox.Text);
            if (FishStockedWeightBox.Text.Trim() != "")
                lotDataRecord.Fish_stocked_weight = Int32.Parse(FishStockedWeightBox.Text);
            if (FeedTypeATextBox.Text.Trim() != "")
                lotDataRecord.Feed_Type_A = FeedTypeATextBox.Text;
            if (FeedTypeBTextBox.Text.Trim() != "")
                lotDataRecord.Feed_Type_B = FeedTypeBTextBox.Text;
            if (AmountFedATextBox.Text.Trim() != "")
                lotDataRecord.Amount_Fed_A = Decimal.Parse(AmountFedATextBox.Text);
            if (AmountFedBTextBox.Text.Trim() != "")
                lotDataRecord.Amount_Fed_B = Decimal.Parse(AmountFedBTextBox.Text);
            if (PriceFedATextBox.Text.Trim() != "")
                lotDataRecord.Unit_Price_Fed_A = Decimal.Parse(PriceFedATextBox.Text);
            if (PriceFedBTextBox.Text.Trim() != "")
                lotDataRecord.Unit_Price_Fed_B = Decimal.Parse(PriceFedBTextBox.Text);
            if (CumLengthBox.Text.Trim() != "")
                lotDataRecord.Length_on_last_day_of_month = Decimal.Parse(CumLengthBox.Text);
            if (NumDaysBox.Text.Trim() != "")
                lotDataRecord.Num_of_days_feed_per_month = Int32.Parse(NumDaysBox.Text);
            if (CommentsTextBox.Text.Trim() != "")
                lotDataRecord.Comments = CommentsTextBox.Text;

        }

        //When the station list is selected
        protected void StationList_SelectedIndexChanged(object sender, EventArgs e)
        {
            LotList.Items.Clear();
            populateLotList();
            MonthList.Items.Clear();
            if (LotList.Items.Count == 0)
                return;
            populateMonthList();
            populateLotTable();
            enableSelectControls();
        }


        //When the lot list is selected
        protected void LotList_SelectedIndexChanged(object sender, EventArgs e)
        {
            MonthList.Items.Clear();
            populateMonthList();
            populateLotTable();
            clearTextBoxes();
            enableSelectControls();
        }

        //When the month list is selected
        protected void MonthList_SelectedIndexChanged(object sender, EventArgs e)
        {
            populateLotTable();
            clearTextBoxes();
            //Enable controls based on the number of the month
            enableSelectControls();

        }
    </script>
<div style="background-color:aqua">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Station&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="StationList" runat="server" style="text-align: center" AutoPostBack="True" OnSelectedIndexChanged="StationList_SelectedIndexChanged">
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
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Lot&nbsp;&nbsp;&nbsp; &nbsp;<asp:DropDownList ID="LotList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="LotList_SelectedIndexChanged">
        </asp:DropDownList>
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;Month&nbsp;&nbsp; <asp:DropDownList ID="MonthList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="MonthList_SelectedIndexChanged">
        </asp:DropDownList>
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;Number of eggs on hand&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="NumEggsTextBox" runat="server"></asp:TextBox>
        <br />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Weight&nbsp;of all the eggs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <asp:TextBox ID="WeightTextBox" runat="server"></asp:TextBox>
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Mortality Rate&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="MortalityRateTextBox" runat="server"></asp:TextBox>
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Inventory Adjustment Number&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="InventoryAdjustmentNumberBox" runat="server"></asp:TextBox>
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Eggs Spawned Number&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="EggsSpawnedNumberBox" runat="server"></asp:TextBox>
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Eggs Picked Off Number&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="EggsPickOffNumBox" runat="server"></asp:TextBox>
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="Label8" runat="server" Text="Eggs Transferred In Number"></asp:Label>
        <asp:TextBox ID="EggsTransferredInNumBox" runat="server"></asp:TextBox>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="Label9" runat="server" Text=" Weight"></asp:Label>
        &nbsp;<asp:TextBox ID="EggsTransferredInWeightBox" runat="server"></asp:TextBox>
    
        <br />
    
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    
        <asp:Label ID="Label6" runat="server" Text="Eggs Transferred Out Number"></asp:Label>
        <asp:TextBox ID="EggsTransferredOutNumBox" runat="server"></asp:TextBox>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="Label7" runat="server" Text=" Weight"></asp:Label>
        &nbsp;<asp:TextBox ID="EggsTransferredOutWeightBox" runat="server"></asp:TextBox>
    
        <br />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="Label3" runat="server" Text="Fish Stocked Number"></asp:Label>
        &nbsp;<asp:TextBox ID="FishStockedNumBox" runat="server"></asp:TextBox>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="Label2" runat="server" Text=" Weight"></asp:Label>
        &nbsp;<asp:TextBox ID="FishStockedWeightBox" runat="server"></asp:TextBox>
    
        <br />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Feed Type A&nbsp;<asp:TextBox ID="FeedTypeATextBox" runat="server"></asp:TextBox>
&nbsp;Amount (lb)
        <asp:TextBox ID="AmountFedATextBox" runat="server"></asp:TextBox>
&nbsp; Unit Price ($)
        <asp:TextBox ID="PriceFedATextBox" runat="server"></asp:TextBox>
        <br />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
        Feed Type B
        <asp:TextBox ID="FeedTypeBTextBox" runat="server"></asp:TextBox>
&nbsp;Amount (lb)
        <asp:TextBox ID="AmountFedBTextBox" runat="server"></asp:TextBox>
&nbsp; Unit Price ($)
        <asp:TextBox ID="PriceFedBTextBox" runat="server"></asp:TextBox>
        <br />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;Length at the end of the month&nbsp;&nbsp;<asp:TextBox ID="CumLengthBox" runat="server"></asp:TextBox>
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Numbers of Days Feeding
        <asp:TextBox ID="NumDaysBox" runat="server"></asp:TextBox>
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
       <div> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <asp:Label ID="Label10" runat="server" Text="Comments" style=" margin-bottom:50px;vertical-align:central"></asp:Label>
&nbsp;
        <asp:TextBox ID="CommentsTextBox" runat="server" TextMode="MultiLine" style ="margin-bottom:-30px" Height="64px" Width="269px"></asp:TextBox>
        </div><br />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="UpdateButton" runat="server" style="margin-top:20px" Text="Update" OnClick="UpdateButton_Click" />
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:HyperLink ID="MainPageHyperLink" NavigateUrl="~/MainPage.aspx" runat="server" Font-Underline="True" ForeColor="#0033CC">Back to Main Page</asp:HyperLink>
        <br />
       
    
</div>
</asp:Content>
