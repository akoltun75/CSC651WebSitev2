<%@ Page Language="C#" MasterPageFile="~/Site.master"%>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
        {
            //If the user is not a valid one, redirect to the login page
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
                Response.Redirect("LoginPage.aspx");
            
        }
</script>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div style="background-color:aqua" class="text-center">
    <br />
         <asp:HyperLink ID="Insert_Lot_Link" NavigateURL="~/InsertLot.aspx" runat="server" style="color:blue; text-decoration: underline">Insert Lot</asp:HyperLink><br /> 
         <asp:HyperLink ID="Delete_Lot_Link" NavigateUrl="~/DeleteLot.aspx"  runat="server" style="color:blue; text-decoration: underline">Delete Lot</asp:HyperLink>
        <br />
         <asp:HyperLink ID="Insert_Lot_History_Link" NavigateUrl="~/InsertLotHistory.aspx" runat="server" style="color:blue; text-decoration: underline">Insert Lot History</asp:HyperLink><br />
         <asp:HyperLink ID="Update_Lot_History_Link" NavigateUrl="~/UpdateLotHistory.aspx" runat="server" style="color:blue; text-decoration: underline">Update Lot History</asp:HyperLink><br />
        <asp:HyperLink ID="Generate_Report_Link" NavigateUrl="~/GenerateReport.aspx"  runat="server" style="color:blue; text-decoration: underline">Generate Report</asp:HyperLink>    
    
        <br />
    <asp:HyperLink ID="Logout_Link" NavigateUrl="~/LoginPage.aspx" runat="server" style="color:blue; text-decoration: underline">Logout</asp:HyperLink>
    </div>
  
</asp:Content>
