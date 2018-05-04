
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CSC650WebProject
{
    public partial class MainPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //If the user is not a valid one, redirect to the login page
            if (Application["User"] != null && Application["User"] != "Yes")
                Response.Redirect("LoginPage.aspx");
            
        }

    }
}