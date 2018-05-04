<%@ Page Language="C#" MasterPageFile="~/Site.master" %>



<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
      <script runat="server">
         protected void Page_Load(object sender, EventArgs e)
        {
            //Redirect if user is not logged in
              if (!HttpContext.Current.User.Identity.IsAuthenticated)
                    Response.Redirect("MainPage.aspx");


        }
</script>
<div style="background-color:aqua;">
    
    <div class="auto-style1" style="color:blue; text-align: center; text-decoration: underline;">
        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/GenerateLotReport.aspx">Generate Lot Report</asp:HyperLink><br />
        <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/GenerateLotHistoryReport.aspx">Generate Lot History Report</asp:HyperLink>
        <br />
        <asp:HyperLink ID="HyperLink3" NavigateUrl="~/MainPage.aspx" runat="server">Back to Main Page</asp:HyperLink>
        </div>
    
</div>
</asp:Content>
